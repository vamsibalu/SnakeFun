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
		public function SnakeFun()
		{
			view = new View(this);
			addChild(view);
		}
	}
}