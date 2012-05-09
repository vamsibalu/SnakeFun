package com.controller
{
	import flash.events.EventDispatcher;

	public class MessageController extends EventDispatcher
	{
		public static const I_GOT_Food:String = "igotfood";
		public static const ADDFOOD_AT:String = "addFoodAt";
		
		public function MessageController(){
		}
	}
}