package com.controller
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.events.CustomEvent;
	import com.model.PlayerDataVO;
	import com.model.Remote;
	import com.view.Board;
	import com.view.View;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import net.user1.reactor.IClient;
	
	public class MoveController extends EventDispatcher{
		private static var thisObj:MoveController;
		public static var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		private var view:View;
		public static var classCount:int = 0;
		public function MoveController(_view:View){
			thisObj = this;
			space_value = 2;
			view = _view;
			//listen for gotfood event that snake will dispatch upon (hit && remoteSnake == false);
			classCount++;
			if (classCount>1) {
				throw new Error("Error:Only Instance Allow Bala..Use MoveController.getInstance() instead of new.");
			}
			
			Remote.getInstance().addEventListener(Remote.SUMBODY_BEFORE_YOU,checkForBoforeYou);
			//Remote.getInstance().addEventListener(Remote.SUMBODY_AFTER_YOU,sendAfterYou);
		}
		
		private function sendAfterYou(e:CustomEvent):void{
			//Board.thisObj.incomingMessages.appendText(getUserName(e.getClient())+ " joined the chat.\n");
			//e.getClient().sendMessage(MsgController.ABOUT_SNAKEDATA,Board.thisObj.currentSnakeStatus().getStr());
		}
		
		private function tellToControllerupdateUserlist():void{
			Board.thisObj.userlist.text = "";
			/*for each (var client:IClient in chatRoom.getOccupants()) {
				tempList++;
				Board.thisObj.userlist.appendText(getUserName(client) + "\n");
				//trace("ddd client=",client)
			}*/
		}
		
		
		protected function updateClientAttributeListener (e:CustomEvent):void {
			/*var changedAttr:Attribute = e.getChangedAttr();
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
				objj.newN =  getUserName(e.getClient());
				trace("ddd Remote dispatching name changed=",objj.oldN," TO ",objj.newN);
				dispatchEvent(new CustomEvent(Remote.SNAKE_NAME_CHANGE,objj));
				Board.thisObj.incomingMessages.appendText(" 's name changed to "+ getUserName(e.getClient())+ ".\n");
				Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
				updateUserList();
			}*/
		}
		
		//chatRoom.addMessageListener(CustomEvent.CHAT_MESSAGE,gotMessageForChat);
		/*protected function gotMessageForChat (fromClient:IClient,messageText:String):void {
			Board.thisObj.incomingMessages.appendText(getUserName(fromClient) + " says: " + messageText+ "\n");
			Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
		}
		
		//chatRoom.addMessageListener(CustomEvent.CHAT_MESSAGE,gotMessageForChat);
		public function tellToAllAboutFood():void{
			chatRoom.sendMessage(MsgController.ADDFOOD_AT,true,null,foodData.getString());
		}*/
		
		
		//chatRoom.addMessageListener(CustomEvent.ABOUT_DIRECTION,gotMessageForDirections);
		/*protected function gotMessageForDirections(fromClient:IClient,messageText:String):void {
		mvController.tellToController_GotDirections(getUserName(fromClient),messageText);
		}*/
		
		//chatRoom.addMessageListener(CustomEvent.ABOUT_SNAKEDATA,gotMessageForSnake);
		/*protected function gotMessageForSnake(fromClient:IClient,messageText:String):void {
			trace("dd1 Remote got messageText1=",messageText)
			var tempPlayer:PlayerDataVO = new PlayerDataVO();
			tempPlayer.setStr(messageText);
			tempPlayer.name = getUserName(fromClient);
			trace("dd1 Remote got messageText2=",tempPlayer.getStr());
			MoveController.getInstance().tellToController_Snake(tempPlayer);
		}*/
		
		private function checkForBoforeYou(e:CustomEvent):void{
			trace("dd1 checkForBoforeYou=",e.data2);
			if(e.data2 == true){
				for each (var client2:IClient in Remote.getInstance().chatRoom.getOccupants()) {
					trace("xx ddd",client2.getAttribute("xx"));
				}
			}
		}
		
		public static function getInstance():MoveController{
			return thisObj;
		}
		
		public function tellToController_Food(e:Event):void{
			trace("dd1 told to controller placeApple");
			placeApple(view.board.mySnake.snake_vector,true);
		}
		
		public function tellToController_Snake(data:PlayerDataVO):void{
			for(var i:int = 0; i<view.board.allSnakes_vector.length; i++){
				if((view.board.allSnakes_vector[i].playerData.name == data.name) && (view.board.allSnakes_vector[i] is RemoteSnake)){
					trace("ddd modifying remoteSnake for",data.name);
					break;
				}
				trace("ddd allSnakes_vector[i].playerData.name",view.board.allSnakes_vector[i].playerData.name," e.data.name=",data.name," allSnakes_vector.length=",view.board.allSnakes_vector.length)
			}
		}
		
		public function tellToController_GotDirections(senderName:String,msg:String):void{
			for(var i:int = 0; i<view.board.allSnakes_vector.length; i++){
				if((view.board.allSnakes_vector[i].playerData.name == senderName) && (view.board.allSnakes_vector[i] is RemoteSnake)){
					trace("ddd modifying remoteSnake Directions for",senderName);
					RemoteSnake(view.board.allSnakes_vector[i]).directionChanged(msg);
					break;
				}
				//trace("ddd allSnakes_vector[i].playerData.name",view.board.allSnakes_vector[i].playerData.name," senderName=",senderName," allSnakes_vector.length=",view.board.allSnakes_vector.length)
			}
		}
		
		public function tellToController_ToSendDirections(e:CustomEvent):void{
			var tempMsg:String = e.data.directon;
			Remote.getInstance().chatRoom.sendMessage(MsgController.ABOUT_DIRECTION,true,null,tempMsg);
			Board.TXT.b.text = tempMsg;
			trace("ddd sending chat message=",tempMsg)
		}
		
		private function placeApple(snake_vector:Vector.<Element>,caught:Boolean = true):void{
			if(apple == null){
				apple = new Element(0xFF0000,1,10, 10);
			}
			apple.catchValue = 0;
			
			if (caught)
				apple.catchValue += 10;
			
			var boundsX:int = (Math.floor(SnakeFun.WIDTH / (snake_vector[0].width + space_value)))-1;
			var randomX:Number = Math.floor(Math.random()*boundsX);
			
			var boundsY:int = (Math.floor(SnakeFun.HEIGHT/(snake_vector[0].height + space_value)))-1;
			var randomY:Number = Math.floor(Math.random()*boundsY);
			
			apple.x = randomX * (apple.width + space_value);
			apple.y = randomY * (apple.height + space_value);
			
			for(var i:uint=0;i<snake_vector.length-1;i++)
			{
				if(snake_vector[i].x == apple.x && snake_vector[i].y == apple.y)
					placeApple(snake_vector,false);
			}
			
			//now place apple anywhere
			Remote.getInstance().foodData.fCount++;
			Remote.getInstance().foodData.fname = "fd"+Remote.getInstance().foodData.fCount;
			Remote.getInstance().foodData.xx = apple.x;
			Remote.getInstance().foodData.yy = apple.y;
			//new food data updated..
			//Remote.getInstance().tellToAllAboutFood();
		}
	}
}