/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package
{
	import com.view.View;
	
	import flash.display.Sprite;
	
	public class SnakeFun extends Sprite
	{
		private var view:View;
		public static var WIDTH:Number;
		public static var HEIGHT:Number;
		
		public function SnakeFun()
		{
			WIDTH = stage.stageWidth;
			HEIGHT = stage.stageHeight;
			view = new View(this);
			addChild(view);
		}
	}
}