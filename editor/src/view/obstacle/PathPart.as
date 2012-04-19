package view.obstacle {
import events.PathPartEvent;

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
	/**
	 * ...
	 * @author Dima
	 */
	public class PathPart extends EventDispatcher {
		public var weight:Sprite;
		public var movePoint:Sprite;
		
		public function PathPart(from:Point, to:Point):void {
			super();
			createWeight(from, to);
			createMovePoint(to);
			movePoint.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function remove():void {
			movePoint.removeEventListener(MouseEvent.CLICK, onClick);
		}

		public function updateStartPoint(x:Number, y:Number):void {
			weight.x = x;
			weight.y = y;
			weight.graphics.clear();
			weight.graphics.lineStyle(2, 0x0333b3);
			weight.graphics.lineTo(movePoint.x - x, movePoint.y - y);
		}
		
		private function createWeight(from:Point, to:Point):void {
			weight = new Sprite();
			weight.x = from.x;
			weight.y = from.y;
			weight.graphics.lineStyle(2, 0x0333b3);
			//weight.graphics.moveTo(from.x, from.y);
			weight.graphics.lineTo(to.x - from.x, to.y - from.y);
		}
		
		private function createMovePoint(point:Point):void {
			movePoint = new Sprite();
			movePoint.x = point.x;
			movePoint.y = point.y;
			movePoint.graphics.beginFill(0xf3543a);
			movePoint.graphics.drawCircle(0, 0, 10);
			movePoint.graphics.endFill();
		}

		private function onClick(event:MouseEvent):void {
			dispatchEvent(new PathPartEvent(PathPartEvent.REMOVE, this));
		}
		
	}

}