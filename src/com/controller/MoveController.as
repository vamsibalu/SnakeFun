package com.controller
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.modal.Remote;
	import com.view.View;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
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
		}
		
		public static function getInstance():MoveController{
			return thisObj;
		}
		
		public function tellToController(e:Event):void{
			trace("dd1 told to controller placeApple")
			placeApple(view.board.mySnake.snake_vector,true);
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
			Remote.getInstance().foodData.xx = String(apple.x);
			Remote.getInstance().foodData.yy = String(apple.y);
			//new food data updated..
			Remote.getInstance().tellToAllAboutFood();
		}
	}
}