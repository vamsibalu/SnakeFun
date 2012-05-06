package com.Elements
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class MySnake extends Snake implements ISnake
	{
		public function MySnake(){
			super();
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
		}
		
		private function addedToStage(e:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
		}
		
		private function directionChanged(e:KeyboardEvent):void {
			var m:Object = new Object(); //MARKER OBJECT
			
			if (e.keyCode == Keyboard.LEFT && last_button_down != e.keyCode && last_button_down != Keyboard.RIGHT && flag)
			{
				snake_vector[0].direction = "L";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"L"};
				last_button_down = Keyboard.LEFT;
				flag = false;
			}
			else if (e.keyCode == Keyboard.RIGHT && last_button_down != e.keyCode && last_button_down != Keyboard.LEFT && flag)
			{
				snake_vector[0].direction = "R";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"R"};
				last_button_down = Keyboard.RIGHT;
				flag = false;
			}
			else if (e.keyCode == Keyboard.UP && last_button_down != e.keyCode && last_button_down != Keyboard.DOWN && flag)
			{
				snake_vector[0].direction = "U";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"U"};
				last_button_down = Keyboard.UP;
				flag = false;
			}
			else if (e.keyCode == Keyboard.DOWN && last_button_down != e.keyCode && last_button_down != Keyboard.UP && flag)
			{
				snake_vector[0].direction = "D";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"D"};
				last_button_down = Keyboard.DOWN;
				flag = false;
			}
			markers_vector.push(m);
		}
	}
}