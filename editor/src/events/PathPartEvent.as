/**
 * User: dima
 * Date: 18/04/12
 * Time: 5:11 PM
 */
package events {
import flash.events.Event;

import view.obstacle.PathPart;

public class PathPartEvent extends Event {
	public var pathPart:PathPart;

	public static const REMOVE:String = "remove";

	public function PathPartEvent(type:String, pathPart:PathPart) {
		super(type);
		this.pathPart = pathPart;
	}
}
}
