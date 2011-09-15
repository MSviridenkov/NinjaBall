package game {
	import flash.display.Sprite;

	public class GameController {
		private var _gameContainer:Sprite;
		private var _enemyController:EnemyController;
		private var _drawController:DrawController;
		
		public function GameController(container:Sprite) {
			_gameContainer = container;
			_enemyController = new EnemyController(_gameContainer);
			_drawController = new DrawController(_gameContainer, _enemyController);
			drawSquareOnContainer();
		}
		
		private function drawSquareOnContainer():void {
			_gameContainer.graphics.beginFill(0xFFFFFF);
			_gameContainer.graphics.drawRect(0, 0, 600, 600);
			_gameContainer.graphics.endFill();
		}
	}
}