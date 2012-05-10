package com.modal
{
	import com.utils.StringParser;

	public class FoodDataVo
	{
		public var fname:String = "";
		public var xx:Number = 50;
		public var yy:Number = 50;
		public var col:int = 0xcccccc;
		public var fCount:int = 0;
		public var rawData:String;
		
		public function getString():String{
			return "fname="+fname+";xx="+xx+";yy="+yy+";col="+col+";foodCount="+String(fCount);
		}
		
		public function setString(str:String):void{
			fname = StringParser.parseValuesAt(str,"fname");
			xx = Number(StringParser.parseValuesAt(str,"xx"));
			yy = Number(StringParser.parseValuesAt(str,"yy"));
			col = int(StringParser.parseValuesAt(str,"col"));
			fCount = int(StringParser.parseValuesAt(str,"fCount"));
			rawData = str;
		}
	}
}