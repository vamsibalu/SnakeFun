package com.modal
{
	public class FoodDataVo
	{
		public var fname:String = "";
		public var xx:String = "";
		public var yy:String = "";
		public var col:String = "0xcccccc";
		
		public function getString():String{
			return "fname="+fname+";xx="+xx+";yy="+yy+";col="+col+";";
		}
	}
}