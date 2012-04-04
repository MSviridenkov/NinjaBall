package view.panel
{
	import flash.display.Sprite;
	/**
	 * Панель опций элемента
	 * @author ProBigi
	 */
	public class OptionsPanel extends Sprite implements IObjectController
	{
		private var _frame:Sprite;
		private var _border:Sprite;
		public function OptionsPanel() {
			init();
		}
		public function init():void {
			createFrame();
			
		}
		public function clear():void {
			var len:int = this.numChildren;
			while (len > 0) { this.removeChildAt(0); len--; }
		}
		private function createFrame():void {
			_frame = new Sprite;
			_frame.graphics.beginFill(0xA0A0A0, .7);
			_frame.graphics.drawRect(0, 0, Main.WIDTH, Main.HEIGHT);
			_frame.graphics.endFill();
			this.addChild(_frame);
			
			_border = new Sprite;
			_border.graphics.lineStyle(1);
			_border.graphics.beginFill(0xFFFFFF);
			_border.graphics.drawRoundRect(0, 0, 250, 200,10,10);
			_border.graphics.endFill();
			_border.x = _frame.width / 2;
			_border.y = _frame.height / 2;
			this.addChild(_border);
		}
	}

}