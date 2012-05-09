package com.view
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.Elements.Snake;
	import com.controller.MoveController;
	import com.events.CustomEvent;
	import com.modal.PlayerDataVO;
	import com.modal.Remote;
	import com.utils.UIObj;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import net.user1.reactor.IClient;
	
	public class Board extends Sprite
	{
		private var mySnake:MySnake;
		
		public var allSnakes_vector:Vector.<Snake> = new Vector.<Snake>();
		public static var thisObj:Board;
		public var moveControll:MoveController;
		
		
		public static const I_GOT_FOOD:String = "igotfood";
		
		
		public function Board(_base:SnakeFun)
		{
			thisObj = this;
			makeDummyUI()
			init();
		}
		
		private function init():void{
			//add Remote Listeners..
			Remote.getThisObj().addEventListener(Remote.IJOINED_ADDMYSNAKE,iJoined_AddMySnake);
			Remote.getThisObj().addEventListener(Remote.SNAKE_NAME_CHANGE,updateSnakeName);
			Remote.getThisObj().addEventListener(Remote.UPDATE_SNAKES_QUANTITY,updateSnakeQuantity);
			Remote.getThisObj().addEventListener(Remote.GOTDATA_FROM_REMOTE,updateTheRemoteSnakeDirection);
		}
		//SSS xx=200;yy=200;col=0xff00ff;
		private function iJoined_AddMySnake(e:CustomEvent):void{
			//add my snake;
			mySnake = new MySnake();
			mySnake.playerData = e.data;
			mySnake.addEventListener(Board.I_GOT_FOOD,Remote.getThisObj().tellToAllAboutFood);
			Remote.getThisObj().chatRoom.addMessageListener("addFoodAt",placeFood_ByRemote);
			mySnake.addEventListener(CustomEvent.MY_KEY_DATA_TO_SEND,needToSendTo_Remote);
			addChild(mySnake);
			allSnakes_vector.push(mySnake);
			trace("ddd iJoined_AddMySnake");
		}
		
		private function needToSendTo_Remote(e:CustomEvent):void{
			var tempMsg:String = e.data.directon+","+"10";
			Remote.getThisObj().chatRoom.sendMessage("CHAT_MESSAGE",true,null,tempMsg);
			outgoingMessages.text = tempMsg;
			trace("ddd sending chat message=",tempMsg)
		}
		
		protected function placeFood_ByRemote (fromClient:IClient,messageText:String):void {
			//placeApple(mySnake.snake_vector);
		}
		
		
		private function addNewSnake(playerData:PlayerDataVO):void{
			var tempRemoteSnake:RemoteSnake = new RemoteSnake();
			tempRemoteSnake.playerData = playerData;
			addChild(tempRemoteSnake);
			allSnakes_vector.push(tempRemoteSnake);
			trace("ddd addNewSnake in Board  for player=",playerData.name," allSnakes.length=",allSnakes_vector.length);
		}
		
		private function updateSnakeQuantity(e:CustomEvent):void{
			var ary:Array = e.data2 as Array;
			for each (var client:IClient in ary) {
				var namee:String = Remote.getThisObj().getUserName(client);
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
		}
		
		private function updateSnakeName(e:CustomEvent):void{
			for(var i:int = 0; i<allSnakes_vector.length; i++){
				trace("ddd updateSnakeName allSnakes.length= ",allSnakes_vector.length," playerDataoldN=",allSnakes_vector[i].playerData.name,"oldN=",e.data2.oldN," newN",e.data2.newN)
				if(allSnakes_vector[i].playerData.name == e.data2.oldN){
					trace("ddd modifying name for",e.data2.oldN,e.data2.newN);
					allSnakes_vector[i].playerData.name = e.data2.newN;
					break;
				}
			}
		}
		
		private function updateTheRemoteSnakeDirection(e:CustomEvent):void{
			incomingMessages.appendText(e.data.name + " says: " + e.data.rawData + "\n");
			incomingMessages.scrollV = incomingMessages.maxScrollV;
			
			for(var i:int = 0; i<allSnakes_vector.length; i++){
				if((allSnakes_vector[i].playerData.name == e.data.name) && (allSnakes_vector[i] is RemoteSnake)){
					trace("ddd modifying remoteSnake for",e.data.name);
					RemoteSnake(allSnakes_vector[i]).directionChanged(e.data.directon);
					break;
				}
				trace("ddd allSnakes_vector[i].playerData.name",allSnakes_vector[i].playerData.name," e.data.name=",e.data.name," allSnakes_vector.length=",allSnakes_vector.length)
			}
		}
		
		
		// User interface objects
		public var incomingMessages:TextField;
		public var outgoingMessages:TextField;
		public var userlist:TextField;
		public var nameInput:TextField;
		
		private function makeDummyUI():void{
			var tempSp:Sprite = new Sprite();
			incomingMessages = UIObj.creatTxt(tempSp,300,200);
			outgoingMessages = UIObj.creatTxt(tempSp,399,20,10,210);
			userlist = UIObj.creatTxt(tempSp,89,200,310);
			nameInput = UIObj.creatTxt(tempSp,100,20,10,240);
			nameInput.addEventListener(KeyboardEvent.KEY_UP,Remote.getThisObj().nameKeyUpListener);
			addChild(tempSp);
		}
		
	}
}