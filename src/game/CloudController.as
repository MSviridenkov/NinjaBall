package game {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	public class CloudController {
		public var _cloud:Sprite;
		private var _gameContainer:Sprite;
		
		public function CloudController(container:Sprite) {
			_gameContainer = container;
			_cloud = new Sprite;
			
			drawCloud(70);
			
			_gameContainer.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function drawCloud(r):void {
			_cloud.graphics.beginFill(0x372A19, .2);
			_cloud.graphics.drawCircle(0, 0, r);
			_cloud.graphics.endFill();
		}
		
		private function onMouseClick(event:MouseEvent):void {
			addCloud(event.stageX, event.stageY);
		}
		
		private function addCloud(x, y):void {
			_cloud.x = x;
			_cloud.y = y;
			_gameContainer.addChild(_cloud);
		}
	}
}
