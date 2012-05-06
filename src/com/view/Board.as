package com.view
{
	import com.Elements.Snake;
	
	import flash.display.Sprite;
	
	public class Board extends Sprite
	{
		private var mySnake:Snake;
		public function Board(_base:SnakeFun)
		{
			init();
		}
		
		private function init():void{
			mySnake = new Snake();
			addChild(mySnake);
		}
	}
}