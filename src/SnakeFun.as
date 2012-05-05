package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SnakeFun extends Sprite
	{
		private var main:Main;
		public function SnakeFun()
		{
			main = new Main();
			addChild(main);
			stage.addEventListener(MouseEvent.CLICK,clicked)
		}
		
		private function clicked(e:MouseEvent):void{
			main.init();
		}
	}
}