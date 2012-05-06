package com.modal
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Remote extends EventDispatcher
	{
		public static var thisObj:Remote;
		public static const NEW_SNAKE:String = "newsnake";
		public function Remote()
		{
			
		}
		
		public static function getThisObj():Remote{
			if(thisObj == null){
				thisObj = new Remote();
			}
			
			return thisObj;
		}
	}
}