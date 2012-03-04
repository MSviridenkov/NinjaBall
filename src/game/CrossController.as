package game {
	import flash.display.Sprite;
	import flash.events.Event;

import game.gameobject.Mill;

public class CrossController {
		public var crosses:Vector.<Sprite>;
		
		private var _gameContainer:Sprite;
		
		public function CrossController(container:Sprite) {
			_gameContainer = container;
			crosses = new Vector.<Sprite>;
			addCross();
			startCrossRot();
		}

		public function remove() {
			stopCrossRot();
			removeCross();
		}
		
		private function addCross():void {
			var cross:Sprite;
			for (var i:int = 0; i < 2; i++) {
				cross = new Sprite;
				cross = createCross(i);
				crosses.push(cross);
				_gameContainer.addChild(cross);
			}
		}

	private function removeCross():void {
		for each (var cross:Sprite in crosses) {
			if (_gameContainer.contains(cross)) { _gameContainer.removeChild(cross); }
		}
	}
		
		private function onEnterFrame(event:Event):void {
			crosses[0].rotation+=.15;
			crosses[1].rotation+=.5;
		}
		
		private function createCross(i:int):Sprite {
			var result:Sprite = new Mill();
			result.x = 120 + i*360;
			result.y = 200 + i*170;
			result.rotation = Math.random() * 360;
			return result;
		}
		
		public function stopCrossRot():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function startCrossRot():void {
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}