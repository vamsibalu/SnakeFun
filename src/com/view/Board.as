package com.view
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.Elements.Snake;
	import com.controller.MoveController;
	import com.controller.MsgController;
	import com.events.CustomEvent;
	import com.model.PlayerDataVO;
	import com.model.Remote;
	import com.utils.UIObj;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import net.user1.reactor.IClient;
	import net.user1.reactor.RoomEvent;
	
	public class Board extends Sprite
	{
		public var mySnake:MySnake;
		
		public var allSnakes_vector:Vector.<Snake> = new Vector.<Snake>();
		public static var thisObj:Board;
		
		
		public function Board(_base:SnakeFun)
		{
			thisObj = this;
			makeDummyUI()
			init();
		}
		
		private function init():void{
			//add Remote Listeners..
			Remote.getInstance().addEventListener(Remote.IJOINED_ADDMYSNAKE,iJoined_AddMySnake);
		}
		
		//SSS xx=200;yy=200;col=0xff00ff;
		private function iJoined_AddMySnake(e:CustomEvent):void{
			//add my snake;
			if(e.data is PlayerDataVO){
				mySnake = new MySnake();
				mySnake.playerData = e.data;
				mySnake.addEventListener(MySnake.I_GOT_FOOD,MoveController.getInstance().tellToController_Food);
				Remote.getInstance().chatRoom.addMessageListener(MsgController.ADDFOOD_AT,placeFood_ByRemote);
				mySnake.addEventListener(CustomEvent.MY_KEY_DATA_TO_SEND,MoveController.getInstance().tellToController_ToSendDirections);
				addChild(mySnake);
				allSnakes_vector.push(mySnake);
				incomingMessages.appendText("You joined the chat.\n");
				trace("dd1 iJoined_AddMySnake");
			}else{
				var roomEvent:RoomEvent = RoomEvent(e.data2);
				incomingMessages.appendText(Remote.getInstance().getUserName(roomEvent.getClient())+ " joined the chat.\n");
				var tempPlayer:PlayerDataVO = new PlayerDataVO();
				tempPlayer.name = Remote.getInstance().getUserName(roomEvent.getClient());
				addNewSnake(tempPlayer);
				trace("dd1 somebody joined the room and send message");
			}
		}
		
		public function currentMySnakeStatus():PlayerDataVO{
			mySnake.playerData.xx = mySnake.x;
			mySnake.playerData.yy = mySnake.y;
			trace("dd1 currentStatus xx=",mySnake.x,mySnake.x);
			return mySnake.playerData;
		}
		
		protected function placeFood_ByRemote (fromClient:IClient,messageText:String):void {
			//placeApple(mySnake.snake_vector);
			trace("dd1 placeFood_ByRemote messageText",messageText)
			Remote.getInstance().foodData.setString(messageText);
			addChild(MoveController.apple);
			MoveController.apple.x = Remote.getInstance().foodData.xx;
			MoveController.apple.y = Remote.getInstance().foodData.yy;
		}
		
		
		private function addNewSnake(playerData:PlayerDataVO):void{
			var tempRemoteSnake:RemoteSnake = new RemoteSnake();
			tempRemoteSnake.playerData = playerData;
			addChild(tempRemoteSnake);
			allSnakes_vector.push(tempRemoteSnake);
			trace("ddd addNewSnake in Board  for player=",playerData.name," allSnakes.length=",allSnakes_vector.length);
		}
		
		/*private function updateSnakeQuantity(e:CustomEvent):void{
			var ary:Array = Remote.getInstance().chatRoom.getOccupants();
			trace("dd1 updateSnakeQuantity",ary)
			for each (var client:IClient in ary) {
				var namee:String = Remote.getInstance().getUserName(client);
				var tempPlayer:PlayerDataVO;
				if(allSnakes_vector.length > 0){
					var alreadyExists:Boolean = false;
					for(var i:int = 0; i<allSnakes_vector.length; i++){
						if(allSnakes_vector[i].playerData.name == namee){
							alreadyExists = true;
							break;
						}
					}
					if(alreadyExists == false){
						tempPlayer = new PlayerDataVO();
						tempPlayer.name = namee;
						addNewSnake(tempPlayer);
					}
				}
			}
		}*/
		//msgController
		public function updateSnakeName(oldN:String,newN:String):void{
			for(var i:int = 0; i<allSnakes_vector.length; i++){
				trace("ddd updateSnakeName allSnakes.length= ",allSnakes_vector.length," playerDataoldN=",allSnakes_vector[i].playerData.name,"oldN=",oldN," newN",newN)
				if(allSnakes_vector[i].playerData.name == oldN){
					trace("ddd modifying name for",oldN,newN);
					allSnakes_vector[i].playerData.name = newN;
					break;
				}
			}
		}
		
		// User interface objects
		public var incomingMessages:TextField;
		public var outgoingMessages:TextField;
		public var userlist:TextField;
		public var nameInput:TextField;
		public static var TXT:Object = new Object();
		private function makeDummyUI():void{
			var tempSp:Sprite = new Sprite();
			incomingMessages = UIObj.creatTxt(tempSp,300,200);
			outgoingMessages = UIObj.creatTxt(tempSp,399,20,10,210);
			TXT.a = incomingMessages;
			TXT.b = outgoingMessages;
			// Keyboard listener for outgoingMessages
			outgoingMessages.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			userlist = UIObj.creatTxt(tempSp,89,200,310);
			nameInput = UIObj.creatTxt(tempSp,100,20,10,240);
			nameInput.addEventListener(KeyboardEvent.KEY_UP,Remote.getInstance().nameKeyUpListener);
			addChild(tempSp);
		}
		
		protected function keyUpListener (e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
				Remote.getInstance().chatRoom.sendMessage(MsgController.CHAT_MESSAGE,true,null,outgoingMessages.text);
				outgoingMessages.text = "";
			}
		}
		
	}
}