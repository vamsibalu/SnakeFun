package com.controller
{
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.events.CustomEvent;
	import com.model.PlayerDataVO;
	import com.model.Remote;
	import com.view.Board;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.user1.reactor.Attribute;
	import net.user1.reactor.IClient;
	import net.user1.reactor.RoomEvent;
	
	public class MsgController extends EventDispatcher{
		private static var thisObj:MsgController;
		public static const ADDFOOD_AT:String = "adfat";
		public static const ABOUT_DIRECTION:String = "abdrct";
		public static const CHAT_MESSAGE:String = "chtmsg";
		
		public static const ATR_SS:String = "atrs";
		
		private var remote:Remote = Remote.getInstance();
		private var board:Board;
		public static var classCount:int = 0;
		
		public function MsgController(_board:Board){
			classCount++;
			if (classCount>1) {
				throw new Error("Error:Only One Instance Allow Bala..Use MoveController.getInstance() instead of new.");
			}
			remote.addEventListener(Remote.ROOMREADY,roomReady);
			remote.addEventListener(Remote.UPDATEUSERLIST,updateUserlist);
			thisObj = this;
			board = _board;
		}
		
		private function roomReady(e:Event):void{
			remote.chatRoom.addMessageListener(CustomEvent.ABOUT_SNAKEDATA,gotMessageForSnake);
			remote.chatRoom.addMessageListener(CustomEvent.CHAT_MESSAGE,gotMessageForChat);
			remote.chatRoom.addMessageListener(CustomEvent.ABOUT_DIRECTION,gotMessageForDirections);
			remote.chatRoom.addEventListener(RoomEvent.UPDATE_CLIENT_ATTRIBUTE,updateClientAttributeListener);
		}
		
		public static function getInstance():MsgController{
			return thisObj;
		}
		
		protected function gotMessageForDirections(fromClient:IClient,messageText:String):void {
			MoveController.getInstance().tellToController_GotDirections(remote.getUserName(fromClient),messageText);
		}
		
		protected function gotMessageForSnake(fromClient:IClient,messageText:String):void {
			trace("dd1 Remote got messageText1=",messageText);
			var tempPlayer:PlayerDataVO = new PlayerDataVO();
			tempPlayer.setStr(messageText);
			tempPlayer.name = remote.getUserName(fromClient);
			trace("dd1 Remote got messageText2=",tempPlayer.getStr());
			MoveController.getInstance().tellToController_Snake(tempPlayer);
		}
		
		protected function gotMessageForChat (fromClient:IClient,messageText:String):void {
			board.incomingMessages.appendText(remote.getUserName(fromClient) + " says: " + messageText+ "\n");
			board.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
		}
		
		public function tellToAllAboutFood():void{
			remote.chatRoom.sendMessage(MsgController.ADDFOOD_AT,true,null,remote.foodData.getString());
		}
		
		// Method invoked when any client in the room
		// changes the value of a shared attribute
		protected function updateClientAttributeListener (e:RoomEvent):void {
			var changedAttr:Attribute = e.getChangedAttr();
			var objj:Object = new Object();
			switch (changedAttr.name){
				case "username":
					if (changedAttr.oldValue == null) {
						Board.thisObj.incomingMessages.appendText("Guest" + e.getClientID());
						objj.oldN = "Guest" + e.getClientID();
					} else {
						Board.thisObj.incomingMessages.appendText(changedAttr.oldValue);
						objj.oldN = changedAttr.oldValue;
					}
					objj.newN =  remote.getUserName(e.getClient());
					trace("ddd Remote dispatching name changed=",objj.oldN," TO ",objj.newN);
					board.updateSnakeName(objj.oldN,objj.newN);
					board.incomingMessages.appendText(" 's name changed to "+ remote.getUserName(e.getClient())+ ".\n");
					board.incomingMessages.scrollV = board.incomingMessages.maxScrollV;
					updateUserlist();
					break;
				case MsgController.ATR_SS:
					var xmlStr:String = e.getClient().getAttribute(MsgController.ATR_SS);
					for(var i:int = 0; i<board.allSnakes_vector.length; i++){
						if(board.allSnakes_vector[i] is RemoteSnake){
							trace("dd1 got attributes",board.allSnakes_vector[i].playerData.name ,"==", remote.getUserName(e.getClient()));
							if(board.allSnakes_vector[i].playerData.name == remote.getUserName(e.getClient())){
								trace("dd1 atribute for snake=",remote.getUserName(e.getClient()),"xml=",xmlStr);
								RemoteSnake(board.allSnakes_vector[i]).setCurrentStatus(xmlStr);
							}
						}
					}
					break;
			}
		}
		
		private function updateUserlist(e:CustomEvent = null):void{
			board.userlist.text = "";
			for each (var client:IClient in remote.chatRoom.getOccupants()) {
				board.userlist.appendText(remote.getUserName(client) + "\n");
				//trace("ddd client=",client)
			}
		}
	}
}