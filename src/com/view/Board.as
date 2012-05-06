package com.view
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.Elements.Snake;
	import com.events.CustomEvent;
	import com.modal.Remote;
	import com.utils.UIObj;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	public class Board extends Sprite
	{
		private var mySnake:MySnake;
		public var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		public var allSnakes_vector:Vector.<Snake>;
		
		
		public static const PLACEFOOD:String = "placefoodpls";
		
		
		public function Board(_base:SnakeFun)
		{
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
			addChild(mySnake);
			
			//add Remote snakes by listening Remote
			Remote.getThisObj().addEventListener(Remote.NEW_SNAKE,addNewSnake)
		}
		
		private function placeFoodRequest(e:Event):void{
			placeApple(Snake(e.target).snake_vector);
		}
		
		private function addNewSnake(e:CustomEvent):void{
			trace("ddd addNewSnake in Board player=",e.data.name)
			var tempRemoteSnake:RemoteSnake = new RemoteSnake();
			tempRemoteSnake.playerData = e.data;
			addChild(tempRemoteSnake);
		}
		
		private function updateAllSnakes():void{
			
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
		protected var incomingMessages:TextField;
		protected var outgoingMessages:TextField;
		protected var userlist:TextField;
		protected var nameInput:TextField;
		
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