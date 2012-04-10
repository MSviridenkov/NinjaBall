package view.cell 
{
import com.greensock.TweenLite;
import com.greensock.TweenMax;

import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * Ячейка
	 * @author ProBigi
	 */
	public class Cell extends Sprite implements IObjectController
	{
		private var _col:Number;
		private var _row:Number;
		public function Cell(col:Number, row:Number) 
		{
			_col = col;
			_row = row;
			init();
		}
		public function init():void {
			graphics.lineStyle(1,0,.3);
			graphics.beginFill(0x89C5C5)
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();
			
			addListeners();
		}
		public function clear():void {
			removeListeners();
			var len:int = this.numChildren;
			while (len > 0) { this.removeChildAt(0); len--; }
		}
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		private function removeListeners():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		private function onOver(e:MouseEvent):void {
			TweenLite.to(this, .3, { alpha : .5 });
		}
		private function onOut(e:MouseEvent):void {
			TweenLite.to(this, .3, { alpha : 1 });
		}
	}
}