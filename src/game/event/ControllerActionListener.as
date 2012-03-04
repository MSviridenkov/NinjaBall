/**
 * Created by IntelliJ IDEA.
 * User: dima
 * Date: 3/3/12
 * Time: 11:06 PM
 * To change this template use File | Settings | File Templates.
 */
package game.event {
import flash.events.Event;

public class ControllerActionListener extends Event {

	public static const OPEN:String = "open";
	public static const CLOSE:String = "close;"

	public function ControllerActionListener(type:String) {
		super(type);
	}
}
}
