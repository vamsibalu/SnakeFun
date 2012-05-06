package com.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class UIObj{
		
		// Create textField and add to ref
		public static function creatTxt (ref:DisplayObjectContainer,ww:Number = 10,hh:Number = 10,border:Boolean = true,bg:Boolean= true,col:int = 0xcccccc):TextField {
			var incomingMessages:TextField = new TextField;
			incomingMessages.border = border;
			incomingMessages.background = bg;
			incomingMessages.backgroundColor = col;
			incomingMessages.width = ww;
			incomingMessages.height = hh;
			ref.addChild(incomingMessages);
			return;
		}
	}
}