package com.controller
{
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
		public static const ABOUT_SNAKEDATA:String = "absnkt";
		public static const ABOUT_DIRECTION:String = "abdrct";
		public static const CHAT_MESSAGE:String = "chtmsg";
		//public static const CHAT_MESSAGE:String = "chtmsg";
		
		private var remote:Remote = Remote.getInstance();
		private var board:Board;
		public static var classCount:int = 0;
		
		public function MsgController(_board:Board){
			classCount++;
			if (classCount>1) {
				throw new Error("Error:Only One Instance Allow Bala..Use MoveController.getInstance() instead of new.");
			}
			remote.addEventListener(Remote.ROOMREADY,roomReady);
			thisObj = this;
			board = _board;
		}
		
		private function roomReady(e:Event):void{
			remote.chatRoom.addMessageListener(CustomEvent.ABOUT_SNAKEDATA,gotMessageForSnake);
			remote.chatRoom.addMessageListener(CustomEvent.CHAT_MESSAGE,gotMessageForChat);
			remote.chatRoom.addMessageListener(CustomEvent.ABOUT_DIRECTION,gotMessageForDirections);
			remote.chatRoom.addMessageListener(Remote.UPDATE_ATTRIBUTES,updateClientAttributeListener);
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
		
		protected function updateClientAttributeListener (event:CustomEvent):void {
			var e:RoomEvent = RoomEvent(event.data2);
			
			var changedAttr:Attribute = e.getChangedAttr();
			var objj:Object = new Object();
			//trace("dd1 atribute changed",changedAttr);
			if (changedAttr.name == "username") {
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
				//updateUserList();
			}
		}
	}
}