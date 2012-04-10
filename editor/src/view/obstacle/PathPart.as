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
			weight.graphics.lineStyle(1, 0x0facb3);
			weight.graphics.moveTo(from.x, from.y);
			weight.graphics.lineTo(to.x, to.y);
		}
		
		private function createMovePoint(point:Point):void {
			movePoint = new Sprite();
			movePoint.graphics.beginFill(0xf3543a);
			weight.graphics.drawCircle(point.x, point.y, 10);
		}
		
	}

}