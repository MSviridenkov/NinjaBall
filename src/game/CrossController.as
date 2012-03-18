package game {
	import flash.display.Sprite;
	import flash.events.Event;

import game.gameobject.Mill;

public class CrossController {
		public var crosses:Vector.<Sprite>;
		
		private var _gameContainer:Sprite;
		private var _rotations:Vector.<Number>;
		private var _numCrosses:Number = Math.round(Math.random() * 4 + 2);
		
		public function CrossController(container:Sprite) {
			_gameContainer = container;
			crosses = new Vector.<Sprite>;
			_rotations = new Vector.<Number>;
			addCross();
			startCrossRot();
		}

		public function remove():void {
			stopCrossRot();
			removeCross();
		}
		
		private function addCross():void {
			var cross:Sprite;
			for (var i:int = 0; i < 5; i++) {
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
			//crosses[0].rotation+=.15;
			//crosses[1].rotation += .5;
			//crosses[2].rotation += .8;
			for (var i:int = 0; i < crosses.length; i++)
			{
				crosses[i].rotation += _rotations[i];
			}
		}
		
		private function createCross(i:int):Sprite {
			var result:Sprite = new Mill();
			result.x = Math.random() * 520 + 55; //120 + i*360;
			result.y = Math.random() * 450 + 55;//200 + i*170;
			_rotations.push(Math.random() * 1);
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