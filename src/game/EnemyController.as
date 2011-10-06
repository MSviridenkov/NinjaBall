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
		private var randoms:Vector.<int>;
		
		public function EnemyController(container:Sprite) {
			_gameContainer = container;
			squares = new Vector.<Sprite>;
			randoms = new Vector.<int>;
			
			random();
			addSquare();
		}
		
		private function drawSquare(sq:Sprite, j:int):void {
			var i:int = j;
			sq.graphics.beginFill(Math.random() * 0xFFFFFF);
			sq.graphics.drawRect(0, 0, 40, 40);
			sq.graphics.endFill();
			sq.x = Math.random() * 560;
			sq.y = randoms[i];
		}
		
		private function addSquare():void {
			for (var i:int = 0; i<5; i++) {
				square = new Sprite;
				drawSquare(square, i);
				squareTween(square);
				squares.push(square);
				_gameContainer.addChild(square);
			}
		}
		
		private function squareTween(sq:Sprite):void {
			var distance:Number;
			var finishX:Number;
			do {
				finishX = Math.random() * 560;
				distance = Math.abs(finishX - sq.x);
			}
			while (distance < 100);
			var speed:Number = Math.random()*150 + 50;
			var time:Number = distance/speed;
			new TweenMax(sq, time, {x: finishX, y: square.y, ease: Linear.easeNone, repeat: -1, yoyo: true});
		}
		
		private function random():void {
			var tempRnd:int;
			var bools:Vector.<Boolean> = new Vector.<Boolean>;
			var canEnd:Boolean = true;
			for (var g:int = 0; g < 5; g++) {
				do {
					tempRnd = Math.random() * (500);
					if (randoms.length != 0) {
						for each (var rnd:int in randoms) {
							if (tempRnd < rnd + 42 && tempRnd > rnd - 42) {
								bools.push(false);
							}
							else {
								bools.push(true);
							}
						}
					}
					for each (var bl:Boolean in bools) {
						if (bools.indexOf(false) == -1) {
							canEnd = true;
						}
						else {
							canEnd = false;
							bools.splice (0, bools.length);
						}
					}
				}
				while (canEnd != true);
				randoms.push(tempRnd);
			}
		}
		
		private function squareMove():void {
			for each (var square:Sprite in squares) {
				if (square.x > 560) {
					squareSpeed = -speeds[squares.indexOf(square)];
				}
				else if (square.x <= 0) {
					squareSpeed = speeds[squares.indexOf(square)];
				}
				square.x += squareSpeed;
			}
		}
		
		private function createSquareSpeed():void {
			for (var i:int = 0; i<5; i++) {
				var rnd:int = Math.random() * 5 + 1;
				speeds.push (rnd);
			}
		}
	}
}