/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package
{
	import com.controller.MoveController;
	import com.view.View;
	
	import flash.display.Sprite;
	
	public class SnakeFun extends Sprite
	{
		private var view:View;
		public static var WIDTH:Number;
		public static var HEIGHT:Number;
		public var moveControll:MoveController;
		
		public function SnakeFun()
		{
			WIDTH = stage.stageWidth;
			HEIGHT = stage.stageHeight;
			view = new View(this);
			addChild(view);
			moveControll = new MoveController(view);
		}
	}
}