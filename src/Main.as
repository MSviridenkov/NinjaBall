package {
	import flash.display.Sprite;
	import game.GameController;
	
	[SWF(width=600, height=600, frameRate=60)]
	
	public class Main extends Sprite {
		private var gameContainer:Sprite;
		public var _gameController:GameController;
		
		public function Main() {
			gameContainer = new Sprite;
			_gameController = new GameController(gameContainer);
			stage.addChild(gameContainer);
		}
	}
}