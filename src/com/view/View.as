package com.view
{
	import flash.display.Sprite;
	
	public class View extends Sprite{
		public var board:Board;
		private var base:SnakeFun;
		
		public function View(_base:SnakeFun){
			base = _base;
			board = new Board(base);
			addChild(board);
		}
	}
}