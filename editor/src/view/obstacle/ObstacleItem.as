package view.obstacle 
{
	import flash.display.Sprite;
	import model.IDItems;
	/**
	 * ...
	 * @author Dima
	 */
	public class ObstacleItem  extends Sprite
	{
		private var _view:Sprite;
		private var _type:int;
		
		public static function craeteObstacle(type:int):ObstacleItem {
			var result:ObstacleItem;
			switch (type) {
				case IDItems.CUBE : result = new SquareObstacle(); break;
				case IDItems.MILL : result = new MillObstacle(); break;
				default: return null;
			}
			return result;
		}
		
		public function ObstacleItem(view:Sprite, type:int):void 
		{
			mouseChildren = false;
			_view = view;
			_type = type;
		}
		
		public function get type():int { return _type; }
		
		public function get view():Sprite { return _view; }
		
	}

}