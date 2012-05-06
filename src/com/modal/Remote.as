/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.modal
{
	import com.events.CustomEvent;
	import com.view.Board;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import net.user1.reactor.Attribute;
	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomEvent;
	import net.user1.reactor.SynchronizationState;
	
	public class Remote extends EventDispatcher
	{
		public static var thisObj:Remote;
		public static const NEW_SNAKE:String = "newsnake";
		public static const GOTDATA_FROM_REMOTE:String = "dataChange";
		public static const SNAKE_NAME_CHANGE:String = "snakenameChange";
		public static const UPDATE_SNAKES_QUANTITY:String = "updatequantity";
		
		private var reactor:Reactor;
		public var chatRoom:Room; //bala for board;
		public function Remote()
		{
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY,readyListener);
			// Connect to the server
			reactor.connect("tryunion.com", 80);
		}
		
		public static function getThisObj():Remote{
			if(thisObj == null){
				thisObj = new Remote();
			}
			
			return thisObj;
		}
		
		// Method invoked when the connection is ready
		protected function readyListener (e:ReactorEvent):void {
			
			chatRoom = reactor.getRoomManager().createRoom("bala");
			
			chatRoom.addMessageListener("CHAT_MESSAGE",chatMessageListener);
			chatRoom.addEventListener(RoomEvent.JOIN,joinRoomListener);
			chatRoom.addEventListener(RoomEvent.ADD_OCCUPANT,addClientListener);
			chatRoom.addEventListener(RoomEvent.REMOVE_OCCUPANT,removeClientListener);
			chatRoom.addEventListener(RoomEvent.UPDATE_CLIENT_ATTRIBUTE,updateClientAttributeListener);
			chatRoom.join();
		}
		
		// Method invoked when a chat messageText(message+score) is received
		protected function chatMessageListener (fromClient:IClient,messageText:String):void {
			trace("ddd Remote got messageText=",messageText)
			var tempPlayer:PlayerDataVO = new PlayerDataVO();
			tempPlayer.name = getUserName(fromClient);
			var ary:Array = messageText.split(",");
			tempPlayer.directon = ary[0].toString();
			tempPlayer.score = ary[1].toString();
			tempPlayer.rawData = messageText;
			dispatchEvent(new CustomEvent(Remote.GOTDATA_FROM_REMOTE,tempPlayer));
		}
		
		// Method invoked when a client joins the room
		protected function addClientListener (e:RoomEvent):void {
			if (e.getClient().isSelf()) {
				Board.thisObj.incomingMessages.appendText("You joined the chat.\n");
				trace("You joined the chat.");
			} else {
				if (chatRoom.getSyncState() != SynchronizationState.SYNCHRONIZING) {
					var tempPlayer:PlayerDataVO = new PlayerDataVO();
					tempPlayer.name = getUserName(e.getClient());
					tempPlayer.directon = "RR";
					tempPlayer.score = "0";
					trace("ddd somebody joined the room dispatching Remote.NEW_SNAKE",tempPlayer);
					dispatchEvent(new CustomEvent(Remote.NEW_SNAKE,tempPlayer));
					// Show a "guest joined" message only when the room isn't performing
					// its initial occupant-list synchronization.
					Board.thisObj.incomingMessages.appendText(getUserName(e.getClient())+ " joined the chat.\n");
				}
			}
			updateUserList();
		}
		
		// Method invoked when the current client joins the room
		protected function joinRoomListener (e:RoomEvent):void {
			updateUserList();
		}
		// Method invoked when a client leave the room
		protected function removeClientListener (e:RoomEvent):void {
			Board.thisObj.incomingMessages.appendText(getUserName(e.getClient())
				+ " left the chat.\n");
			Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
			updateUserList();
		}
		
		// Helper method to display the room's
		// clients in the user list
		private var userList:int = 1;
		protected function updateUserList ():void {
			var tempList:int = 0;
			Board.thisObj.userlist.text = "";
			for each (var client:IClient in chatRoom.getOccupants()) {
				tempList++;
				Board.thisObj.userlist.appendText(getUserName(client) + "\n");
			}
			
			//for new snakes add or remove..
			if(userList != tempList){
				userList = tempList;
				trace("ddd List Snakes Updating2...",userList)
				dispatchEvent(new CustomEvent(Remote.UPDATE_SNAKES_QUANTITY,chatRoom.getOccupants()));
			}
		}
		
		// Helper method to retrieve a client's user name.
		// If no user name is set for the specified client,
		// returns "Guestn" (where 'n' is the client's id).  
		protected function getUserName (client:IClient):String {
			var username:String = client.getAttribute("username");
			if (username == null){
				return "Guest" + client.getClientID();
			} else {
				return username;
			}
		}
		
		// Method invoked when any client in the room
		// changes the value of a shared attribute
		protected function updateClientAttributeListener (e:RoomEvent):void {
			var changedAttr:Attribute = e.getChangedAttr();
			trace("Attribute ",changedAttr.name)
			if (changedAttr.name == "username") {
				if (changedAttr.oldValue == null) {
					Board.thisObj.incomingMessages.appendText("Guest" + e.getClientID());
				} else {
					Board.thisObj.incomingMessages.appendText(changedAttr.oldValue);
				}
				var objj:Object = new Object();
				objj.oldN = changedAttr.oldValue;
				objj.newN =  getUserName(e.getClient());
				trace("ddd Remote dispatching name changed=",objj.newN);
				dispatchEvent(new CustomEvent(Remote.SNAKE_NAME_CHANGE,objj));
				Board.thisObj.incomingMessages.appendText(" 's name changed to "+ getUserName(e.getClient())+ ".\n");
				Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
				updateUserList();
			}
		}
		
		// Keyboard listener for nameInput
		public function nameKeyUpListener (e:KeyboardEvent):void {
			var self:IClient;
			if (e.keyCode == Keyboard.ENTER) {
				self = reactor.self();
				self.setAttribute("username", e.target.text);
				e.target.text = "";
			}
		}
	}
}