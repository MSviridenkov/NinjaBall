/**
 * Created by : Dmitry
 * Date: 4/4/12
 * Time: 6:56 AM
 */
package view.obstacle {
	import model.IDItems;
public class SquareObstacle extends ObstacleItem {
	private var _model:SquareObstacleModel;
	
	public function SquareObstacle() {
		super(new SquareView(), IDItems.CUBE);
		_model = new SquareObstacleModel();
		view.x = view.width;
		view.y = view.height;
		this.addChild(view);
	}
}
}
