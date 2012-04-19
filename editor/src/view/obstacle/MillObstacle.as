/**
 * User: dima
 * Date: 19/04/12
 * Time: 4:06 PM
 */
package view.obstacle {
import flash.display.Sprite;

import model.IDItems;

public class MillObstacle extends ObstacleItem {

	public function MillObstacle() {
		super(new Sprite(), IDItems.MILL);
		super.view.addChild(new MillHorizontalView());
		super.view.addChild(new MillVerticalView());
		this.addChild(super.view);
	}
}
}
