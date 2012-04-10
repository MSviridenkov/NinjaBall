/**
 * Created by : Dmitry
 * Date: 4/4/12
 * Time: 6:56 AM
 */
package view.obstacle {
	import flash.display.Sprite;
	import model.IDItems;
public class SquareObstacle extends ObstacleItem {
	private var _model:SquareObstacleModel;
	private var _pathParts:Vector.<PathPart>;
	
	public function SquareObstacle() {
		super(new SquareView(), IDItems.CUBE);
		_model = new SquareObstacleModel();
		view.x = view.width;
		view.y = view.height;
		this.addChild(view);
	}
	
	public function addPathPart(pathPart:PathPart):void {
		if (!_pathParts) { _pathParts = new Vector.<PathPart>(); }
		_pathParts.push(pathPart);
	}
	
	public function removePathPart(pathPart:PathPart):void {
		var index:int = _pathParts.indexOf(pathPart);
		if (index != -1) { _pathParts.splice(index, 1); }
	}
	
	public function getLastPathPart():PathPart {
		if (!_pathParts || _pathParts.length == 0) { return null; }
		else {
			return _pathParts[_pathParts.length - 1];
		}
	}
}
}
