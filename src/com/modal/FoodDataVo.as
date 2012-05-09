package com.modal
{
	import com.utils.StringParser;

	public class FoodDataVo
	{
		public var fname:String = "";
		public var xx:String = "";
		public var yy:String = "";
		public var col:String = "0xcccccc";
		
		public function getString():String{
			return "fname="+fname+";xx="+xx+";yy="+yy+";col="+col+";";
		}
		
		public function setString(str:String):void{
			fname = StringParser.parseValuesAt(str,"fname");
			xx = StringParser.parseValuesAt(str,"xx");
			yy = StringParser.parseValuesAt(str,"yy");
			col = StringParser.parseValuesAt(str,"col");
		}
	}
}