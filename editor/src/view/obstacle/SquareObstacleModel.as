package view.obstacle 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Dima
	 */
	public class SquareObstacleModel {
		private var _movingPath:Vector.<Point>;
		
		public function SquareObstacleModel() {
			
		}
		
		public function get movingPath():Vector.<Point> { return _movingPath; }
		
		public function addMovingPoint(point:Point):void {
			if (!_movingPath) { _movingPath = new Vector.<Point>(); }
			_movingPath.push(point);
		}
		
	}

}