package com.view
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.Elements.Snake;
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
		public var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		public var allSnakes_vector:Vector.<Snake> = new Vector.<Snake>();
		public static var thisObj:Board;
		
		
		public static const PLACEFOOD:String = "placefoodpls";
		
		
		public function Board(_base:SnakeFun)
		{
			thisObj = this;
			makeDummyUI()
			space_value = 2;
			init();
		}
		
		private function init():void{
			apple = new Element(0xFF0000, 1,10, 10); //red, not transparent, width:10, height: 10;
			apple.catchValue = 0; //pretty obvious
			
			//add my snake;
			mySnake = new MySnake();
			mySnake.addEventListener(Board.PLACEFOOD,placeFoodRequest);
			mySnake.addEventListener(CustomEvent.MY_KEY_DATA_TO_SEND,needToSendTo_Remote);
			addChild(mySnake);
			allSnakes_vector.push(mySnake);
			//add Remote snakes by listening Remote
			Remote.getThisObj().addEventListener(Remote.NEW_SNAKE,addNewSnake);
			Remote.getThisObj().addEventListener(Remote.GOTDATA_FROM_REMOTE,updateTheRemoteSnakeDirection);
			Remote.getThisObj().addEventListener(Remote.SNAKE_NAME_CHANGE,updateSnakeName);
			Remote.getThisObj().addEventListener(Remote.UPDATE_SNAKES_QUANTITY,updateSnakeQuantity);
		}
		
		private function needToSendTo_Remote(e:CustomEvent):void{
			var tempMsg:String = e.data.directon+","+"10";
			Remote.getThisObj().chatRoom.sendMessage("CHAT_MESSAGE",true,null,tempMsg);
			outgoingMessages.text = tempMsg;
			trace("ddd sending chat message=",tempMsg)
		}
		
		private function placeFoodRequest(e:Event):void{
			placeApple(Snake(e.target).snake_vector);
		}
		
		private function addNewSnake(e:CustomEvent):void{
			trace("ddd addNewSnake in Board  for player2=",e.data.name);
			var tempRemoteSnake:RemoteSnake = new RemoteSnake();
			tempRemoteSnake.playerData = e.data;
			addChild(tempRemoteSnake);
			allSnakes_vector.push(tempRemoteSnake);
		}
		
		private function updateSnakeQuantity(e:CustomEvent):void{
			var ary:Array = e.data2 as Array;
			for each (var client:IClient in ary) {
				var namee:String = Remote.getThisObj().getUserName(client);
				for(var i:int = 0; i<allSnakes_vector.length; i++){
					if(allSnakes_vector[i].playerData.name!=namee){
						var tempPlayer:PlayerDataVO = new PlayerDataVO();
						tempPlayer.name = namee;
						addNewSnake(new CustomEvent("",tempPlayer));
						trace("ddd added new Snake updated quantity",namee);
						break;
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
		
		private function placeApple(snake_vector:Vector.<Element>,caught:Boolean = true):void{
			if (caught)
				apple.catchValue += 10;
			
			var boundsX:int = (Math.floor(stage.stageWidth / (snake_vector[0].width + space_value)))-1;
			var randomX:Number = Math.floor(Math.random()*boundsX);
			
			var boundsY:int = (Math.floor(stage.stageHeight/(snake_vector[0].height + space_value)))-1;
			var randomY:Number = Math.floor(Math.random()*boundsY);
			
			apple.x = randomX * (apple.width + space_value);
			apple.y = randomY * (apple.height + space_value);
			
			for(var i:uint=0;i<snake_vector.length-1;i++)
			{
				if(snake_vector[i].x == apple.x && snake_vector[i].y == apple.y)
					placeApple(snake_vector,false);
			}
			if (!apple.stage)
				this.addChild(apple);
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