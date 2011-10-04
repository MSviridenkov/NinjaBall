package game {
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;

	public class EnemyController {
		public var square:Sprite;
		public var squares:Vector.<Sprite>;
		private var _gameContainer:Sprite;
		private var speeds:Vector.<int>;
		private var squareSpeed:int;
		//private var _timer:Timer;
		
		public function EnemyController(container:Sprite) {
			_gameContainer = container;
			//squareSpeed = 3;
			squares = new Vector.<Sprite>;
			//speeds = new Vector.<int>;
			addSquare();
			//createSquareSpeed();
			//_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function drawSquare(sq:Sprite):void {
			sq.graphics.beginFill(Math.random() * 0xFFFFFF);
			sq.graphics.drawRect(0, 0, 40, 40);
			sq.graphics.endFill();
			sq.x = Math.random() * 560;
			sq.y = Math.random() * 500;
		}
		
		private function addSquare():void {
<<<<<<< HEAD
			for (var i:int = 0; i<30; i++) {
=======
			for (var i:int = 0; i<5; i++) {
>>>>>>> Traps are moving. Ball is removed, when it hits something trap.
				square = new Sprite;
				drawSquare(square);
				squareTween(square);
				squares.push(square);
				_gameContainer.addChild(square);
				
			}
		}
		
<<<<<<< HEAD
		private function squareMove(sq:Sprite):void {
			new TweenMax(sq, 1, {x: 560, y: square.y, ease: Linear.easeNone, repeat: -1, yoyo: true});
		}
		
		public function pauseTweens(b:Boolean):void {
			TweenMax.pauseAll(b);
		}
		
		public function resumeTweens(b:Boolean):void {
			TweenMax.resumeAll(b);
=======
		private function onEnterFrame(event:Event):void {
			squareMove();
		}
		
		private function squareMove():void {
			for each (var square:Sprite in squares) {
				//squareSpeed = speeds[squares.indexOf(square)];
				if (square.x > 560) {
					squareSpeed = -speeds[squares.indexOf(square)];
				}
				else if (square.x <= 0) {
					squareSpeed = speeds[squares.indexOf(square)];
				}
				square.x += squareSpeed;
				//trace ("square", squares.indexOf(square) + 1, "x:", square.x, "speed:", squareSpeed);
			}
		}
		
		private function createSquareSpeed():void {
			for (var i:int = 0; i<5; i++) {
				var rnd:int = Math.random() * 5 + 1;
				speeds.push (rnd);
			}
			trace ("speeds", speeds);
		}
		
		private function addSquareSpeed():void {
			/*for each (var square:Sprite in squares) {
					squareSpeed = speeds[squares.indexOf(square)];
				}
				trace ("speed", squareSpeed)*/
		}
		
		private function squareTween(sq:Sprite):void {
			var distancies:Vector.<Number>;
			distancies = new Vector.<Number>;
			var finishX:Number = Math.random() * 560;
			var distance:Number = Math.abs(finishX - sq.x);
			distancies.push(distance);
			for each (var dis:Number in distancies) {
				if (dis < 100) {
					distancies[distancies.indexOf(dis)] = Math.abs(finishX - sq.x) + 100;
				}
				var speed:Number = Math.random()*150 + 50;
				var time:Number = distance/speed;
			}
			trace ("start x:", sq.x);
			trace ("finish x:", finishX);
			trace ("time:", time);
			trace ("speed:", speed)
			trace ("distance", distance, "\n");
			new TweenMax(sq, time, {x: finishX, y: square.y, ease: Linear.easeNone, repeat: -1, yoyo: true});
>>>>>>> Traps are moving. Ball is removed, when it hits something trap.
		}
	}
}