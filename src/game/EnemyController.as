package game {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EnemyController {
		public var square:Sprite;
		public var tweenSquare: TweenMax;
		
		private var _timer:Timer;
		
		public function EnemyController() {
			square = new Sprite;
			drawSquare(0, 300);
			squareMove(560, 300);
			initTimer();
			startTimer();
		}
		
		private function drawSquare(x:int, y:int):void {
			square.graphics.beginFill(0xFFe500);
			square.graphics.drawRect(0, 0, 40, 40);
			square.graphics.endFill();
			square.x = x;
			square.y = y;
		}
		
		private function squareMove(x:int, y:int):void {
			tweenSquare = new TweenMax(square, 1, {x: x, y: y, ease: Linear.easeNone});
		}
		
		private function onTimer(event:TimerEvent):void {
			if (square.x == 560 && square.y == 300) {
				squareMove(0, 300);
			}
			if (square.x == 0 && square.y == 300) {
				squareMove(560, 300);
			}
		}
		
		private function initTimer():void {
			_timer = new Timer(20);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function startTimer():void {
			_timer.start();
		}
		
		public function stopTimer():void {
			_timer.stop();
		}
	}
}