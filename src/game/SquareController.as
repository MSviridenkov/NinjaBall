package game {
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;

	public class SquareController {
		public var square:Sprite;
		public var squares:Vector.<SquareView>;
		
		private var _gameContainer:Sprite;
		private var speeds:Vector.<int>;
		private var squareSpeed:int;
		private var randoms:Vector.<int>;
		private var _positions:Vector.<Number>;
		private var _numSquares:Number = Math.round(Math.random() * 6 + 2);
		
		public function SquareController(container:Sprite) {
			_gameContainer = container;
			squares = new Vector.<SquareView>;
			randoms = new Vector.<int>;
			
			//random();
			addSquare();
			
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}

		public function remove():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			removeSquare();
		}
		
		/*
		private function createSquare(i:int):Sprite {
			var result:Sprite = new SquareView();
			result.x = Math.random() * 560;
			result.y = randoms[i];
			result.scaleX = result.scaleY = GameController.SCALE_OBJ;
			return result;
		}
		private function drawSquare(sq:Sprite, j:int):void {
			sq.graphics.beginFill(Math.random() * 0xFFFFFF);
			sq.graphics.drawRect(0, 0, 40, 40);
			sq.graphics.endFill();
			sq.x = Math.random() * 560;
			sq.y = randoms[j];
		}
		*/
		
		private function addSquare():void {
			for (var i:int = 0; i < _numSquares; i++) {
				var cube:SquareView = new SquareView;
				cube.x = Math.random() * 560;
				var posY:Number = Math.random() * 460 + 60;
				cube.y = posY;
				if (i > 0) {
					var len:int = 0;
					do {
						posY = Math.random() * 460 + 60;
						cube.y = posY;
						len++;
						if (len > 50) { throw new ArgumentError("Too Much Iterations!!!"); }
					}
					while (checkPosition(cube));
				}
				
				squares.push(cube);
				_gameContainer.addChild(cube);
				squareTween(cube);
			}
		}
		private function checkPosition(cube:SquareView):Boolean
		{
			for each(var square:SquareView in squares)
			{
				if ( cube.y > (square.y - square.width) && cube.y < (square.y + square.width) )
				{
					return true;
				}
			}
			return false;
		}
		
		private function removeSquare():void {
			for each (var square:Sprite in squares) {
				if (_gameContainer.contains(square)) { _gameContainer.removeChild(square); }
			}
		}
		
		private function squareTween(sq:SquareView):void {
			var distance:Number;
			var finishX:Number;
			do {
				finishX = Math.random() * 560;
				distance = Math.abs(finishX - sq.x);
			}
			while (distance < 100);
			var speed:Number = Math.random()*150 + 50;
			var time:Number = distance/speed;
			new TweenMax(sq, time, {x: finishX, y: sq.y, ease: Linear.easeNone, repeat: -1, yoyo: true});
		}
		
		//WTF??? O_o ))
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
		
		// xD
		private function onEnterFrame(event:Event):void {
			
		}
		
		//не используется
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
		
		//не используется
		private function createSquareSpeed():void {
			for (var i:int = 0; i<5; i++) {
				var rnd:int = Math.random() * 5 + 1;
				speeds.push (rnd);
			}
		}
	}
}