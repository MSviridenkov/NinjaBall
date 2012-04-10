package view.obstacle {
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Dima
	 */
	public class PathPart {
		public var weight:Sprite;
		public var movePoint:Sprite;
		
		public function PathPart(from:Point, to:Point):void {
			super();
			createWeight(from, to);
			createMovePoint(to);
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
		
	}

}