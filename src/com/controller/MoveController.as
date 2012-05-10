package com.controller
{
	import com.Elements.Element;
	import com.Elements.MySnake;
	import com.Elements.RemoteSnake;
	import com.events.CustomEvent;
	import com.modal.PlayerDataVO;
	import com.modal.Remote;
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
		}
		
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
			Remote.getInstance().tellToAllAboutFood();
		}
	}
}