/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/4/12
 * Time: 1:33 PM
 * To change this template use File | Settings | File Templates.
 */
package game.gameobject {
import flash.display.Sprite;

public class Mill extends Sprite {
	public function Mill() {
		addChild(new MillHorizontalView());
		addChild(new MillVerticalView());
	}
}
}
