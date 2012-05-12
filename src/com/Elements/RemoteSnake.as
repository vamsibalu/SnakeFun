/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.Elements
{
	import flash.ui.Keyboard;
	
	public class RemoteSnake extends Snake implements ISnake{
		
		public function RemoteSnake(){
			super(true);
		}
		
		//hey bala use this function with RemoteData;
		public function directionChanged(direction:String):void {
			var m:Object = new Object(); //MARKER OBJECT
			
			if (direction == "LL")
			{
				snake_vector[0].direction = "L";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"L"};
				last_button_down = Keyboard.LEFT;
				flag = false;
			}
			else if (direction == "RR")
			{
				snake_vector[0].direction = "R";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"R"};
				last_button_down = Keyboard.RIGHT;
				flag = false;
			}
			else if (direction == "UU")
			{
				snake_vector[0].direction = "U";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"U"};
				last_button_down = Keyboard.UP;
				flag = false;
			}
			else if (direction == "DD")
			{
				snake_vector[0].direction = "D";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"D"};
				last_button_down = Keyboard.DOWN;
				flag = false;
			}
			markers_vector.push(m);
		}
		
		public function setCurrentStatus(xmlStr:String):void{
			trace("dd1 doint setCurrentStatus",xmlStr,playerData.name);
			
		}
	}
}