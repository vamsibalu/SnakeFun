package com.modal
{
	import com.utils.StringParser;

	public final class PlayerDataVO
	{
		public var name:String = "";
		public var directon:String = "";
		public var score:String = "";
		public var col:String = "";
		public var rawData:String = "";
		
		
		public function getStr():String{
			return "name="+name+";directon="+directon+";score="+score+";col="+col;
		}
		
		public function setStr(str:String):void{
			name = StringParser.parseValuesAt(str,"name");
			directon = StringParser.parseValuesAt(str,"directon");
			score = StringParser.parseValuesAt(str,"score");
			col = StringParser.parseValuesAt(str,"col");
			rawData = str;
		}
	}
}