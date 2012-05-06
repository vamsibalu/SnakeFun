package com.modal
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Remote extends EventDispatcher
	{
		public function Remote(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}