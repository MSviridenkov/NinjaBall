package game {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EnemyController {
		public var square:Sprite;
		private var _timer:Timer;
		
		public function EnemyController() {
			square = new Sprite;
			drawSquare();
			initTimer();
			startTimer();
		}
		
		private function drawSquare():void {
			square.graphics.beginFill(0xFFe500);
			square.graphics.drawRect(0, 0, 40, 40);
			square.graphics.endFill();
			square.x = 0;
			square.y = 300;
		}
		
		private function squareMove(x:int, y:int):void {
			TweenMax.to(square, 5, {x : x, y : y, ease : Linear.easeNone, onUpdate : function():void {trace (square.x, square.y);}});
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
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function startTimer():void {
			_timer.start();
		}
	}
}