package game {
	import flash.display.Sprite;
	import flash.events.Event;

	public class CrossController extends Sprite {
		public var crosses:Vector.<Sprite>;
		
		private var _cross:Sprite;
		private var _gameContainer:Sprite;
		
		public function CrossController(container:Sprite) {
			_gameContainer = container;
			crosses = new Vector.<Sprite>;
			addCross();
			startCrossRot();
		}
		
		private function addCross():void {
			for (var i:int = 0; i < 2; i++) {
				_cross = new Sprite;
				createCross(_cross, i);
				crosses.push(_cross);
				_gameContainer.addChild(_cross);
			}
		}
		
		private function onEnterFrame(event:Event):void {
			crosses[0].rotation+=.15;
			crosses[1].rotation+=.5;
		}
		
		private function createCross(cross:Sprite, i:int):void {
			cross.graphics.beginFill(0x996600);
			cross.graphics.drawRect(-100, -15, 200, 30);
			cross.graphics.endFill();
			cross.graphics.beginFill(0x996600);
			cross.graphics.drawRect(-15, -100, 30, 200);
			cross.graphics.endFill();
			cross.x = 200 + i*200;//Math.random() * 200 + 200;
			cross.y = 200 + i*200;//Math.random() * 200 + 200;
			cross.rotation = Math.random() * 360;
		}
		
		public function stopCrossRot():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function startCrossRot():void {
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}