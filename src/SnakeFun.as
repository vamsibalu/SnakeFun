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