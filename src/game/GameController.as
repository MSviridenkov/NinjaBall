package game {
	import flash.display.Sprite;

	public class GameController {
		private var _gameContainer:Sprite;
		private var _enemyController:EnemyController;
		private var _drawController:DrawController;
		private var _ball:Sprite;
		private var _canCheck:Boolean;
		
		public function GameController(container:Sprite) {
			_gameContainer = container;
			_canCheck = true;
			drawBall();
			drawSquareOnContainer();
			_enemyController = new EnemyController(_gameContainer);
			_drawController = new DrawController(_gameContainer, _enemyController, _ball);
			_gameContainer.addChild(_ball);
			//_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function drawSquareOnContainer():void {
			_gameContainer.graphics.beginFill(0xFFFFFF);
			_gameContainer.graphics.drawRect(0, 0, 600, 600);
			_gameContainer.graphics.endFill();
		}
		
		
		private function drawBall():void {
			_ball = new Sprite;
			_ball.graphics.beginFill(0xF567F8);
			_ball.graphics.drawCircle(0, 0, 20);
			_ball.graphics.endFill();
			_ball.x = 300;
			_ball.y = 570;
		}
		/*
		private function onEnterFrame(event:Event):void {
			checkBallHitSquare();
		}
		
		private function checkBallHitSquare():void {
			for each (var square:Sprite in _enemyController.squares) {
				if (_ball.hitTestObject(square) == true) {
					//_drawController.removeSecondListener();
					//_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					//_gameContainer.removeChild(_ball);
					trace ("bum");
				}
				//break;
			}
		}*/
	}
}