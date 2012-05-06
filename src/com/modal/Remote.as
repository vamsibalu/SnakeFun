/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.modal
{
	import com.events.CustomEvent;
	
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
		public static const DATA_CHANGE:String = "dataChange";
		
		private var reactor:Reactor;
		protected var chatRoom:Room;
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
			var tempPlayer:PlayerDataVO = new PlayerDataVO();
			tempPlayer.name = getUserName(fromClient);
			var ary:Array = messageText.split(",");
			tempPlayer.directon = ary[0].toString();
			tempPlayer.score = ary[1].toString();
			dispatchEvent(new CustomEvent(CustomEvent.REMOTEDATA_CHANGE,tempPlayer));
		}
		
		// Method invoked when a client joins the room
		protected function addClientListener (e:RoomEvent):void {
			if (e.getClient().isSelf()) {
				trace("You joined the chat.");
			} else {
				if (chatRoom.getSyncState() != SynchronizationState.SYNCHRONIZING) {
					var tempPlayer:PlayerDataVO = new PlayerDataVO();
					tempPlayer.name = getUserName(e.getClient());
					tempPlayer.directon = "RR";
					tempPlayer.score = "0";
					
					dispatchEvent(new CustomEvent(Remote.NEW_SNAKE,tempPlayer));
					// Show a "guest joined" message only when the room isn't performing
					// its initial occupant-list synchronization.
					//incomingMessages.appendText(getUserName(e.getClient())+ " joined the chat.\n");
				}
			}
			//updateUserList();
		}
		
		// Method invoked when the current client joins the room
		protected function joinRoomListener (e:RoomEvent):void {
			//updateUserList();
		}
		// Method invoked when a client leave the room
		protected function removeClientListener (e:RoomEvent):void {
			/*incomingMessages.appendText(getUserName(e.getClient())
				+ " left the chat.\n");
			incomingMessages.scrollV = incomingMessages.maxScrollV;
			updateUserList();*/
		}
		
		
		// Helper method to retrieve a client's user name.
		// If no user name is set for the specified client,
		// returns "Guestn" (where 'n' is the client's id).  
		protected function getUserName (client:IClient):String {
			var username:String = client.getAttribute("username");
			if (username == null) {
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
			/*if (changedAttr.name == "username") {
				if (changedAttr.oldValue == null) {
					incomingMessages.appendText("Guest" + e.getClientID());
				} else {
					incomingMessages.appendText(changedAttr.oldValue);
				}
				incomingMessages.appendText(" 's name changed to "
					+ getUserName(e.getClient())
					+ ".\n");
				incomingMessages.scrollV = incomingMessages.maxScrollV;
				updateUserList();
			}*/
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