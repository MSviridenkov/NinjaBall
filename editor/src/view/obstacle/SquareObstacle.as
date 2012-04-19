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
		//view.x = view.width;
		//view.y = view.height;
		this.addChild(view);
	}
	
	public function addPathPart(pathPart:PathPart):void {
		if (!_pathParts) { _pathParts = new Vector.<PathPart>(); }
		_pathParts.push(pathPart);
	}

	public function updateFirstPathPart():void {
		if (_pathParts && _pathParts.length > 0) {
			_pathParts[0].updateStartPoint(x, y);
		}
	}

	public function getPathPartAndUpper(pathPart):Vector.<PathPart> {
		var index:int = _pathParts.indexOf(pathPart);
		var result:Vector.<PathPart> = new Vector.<PathPart>();
		if (index != -1) {
			for (var i:int = index; i < _pathParts.length; ++i) {
				result.push(_pathParts[i]);
			}
		}
		return result;
	}

	public function removePathPartAndUpper(pathPart):void {
		var index:int = _pathParts.indexOf(pathPart);
		if (index != -1) {
			_pathParts.splice(index, _pathParts.length-index);
		}
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
