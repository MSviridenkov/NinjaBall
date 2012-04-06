package events 
{
	import flash.events.Event;
	import view.obstacle.ObstacleItem;
	/**
	 * ...
	 * @author Dima
	 */
	public class ItemPanelEvent extends Event {
		public var item:ObstacleItem;
		
		public static const ADD_ITEM:String = "addItem";
		
		public function ItemPanelEvent(type:String, item:ObstacleItem) {
			super(type);
			this.item = item;
		}
		
	}

}