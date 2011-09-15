package game {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EnemyController {
		public var square:Sprite;
		public var tweenSquare:TweenMax;
		public var squares:Vector.<Sprite>;
		private var _gameContainer:Sprite;
		private var _timer:Timer;
		
		public function EnemyController(container:Sprite) {
			_gameContainer = container;
			squares = new Vector.<Sprite>;
			addSquare();
			for each (var sq:Sprite in squares) {
				
			}
		}
		
		private function drawSquare(sq:Sprite):void {
			sq.graphics.beginFill(0xFFe500);
			sq.graphics.drawRect(0, 0, 40, 40);
			sq.graphics.endFill();
			sq.x = 0;
			sq.y = Math.random() * 600;
		}
		
		private function addSquare():void {
			for (var i:int = 0; i<15; i++) {
				square = new Sprite;
				drawSquare(square);
				squareMove(square);
				squares.push(new Sprite);
				_gameContainer.addChild(square);
			}
		}
		
		private function squareMove(sq:Sprite):void {
			tweenSquare = new TweenMax(sq, 1, {x: 560, y: square.y, ease: Linear.easeNone, repeat: -1, yoyo: true});
		}
	}
}