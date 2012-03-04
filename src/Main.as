package {
import flash.display.Sprite;
	import flash.events.Event;
	
	import game.GameController;
	import game.Menu;
import game.event.ControllerActionListener;

[SWF(width=600, height=600, frameRate=60)]
	
public class Main extends Sprite {
	var _mochiads_game_id:String = "c476fc4588090ec2";

	public var gameContainer:Sprite;
	public var upContainer:Sprite;

	private var _gameController:GameController;
	private var _menuController:Menu;

	public static const WIDTH:int = 600;
	public static const HEIGHT:int = 600;

	public function Main() {
		gameContainer = new Sprite;
		addChild(gameContainer);
		_menuController = new Menu(gameContainer);
		_gameController = new GameController(gameContainer);
		_menuController.addEventListener(ControllerActionListener.CLOSE, onMenuClose);
		_gameController.addEventListener(ControllerActionListener.CLOSE, onGameClose);
		_gameController.addEventListener(ControllerActionListener.OPEN, onGameOpen);

		_menuController.open();
	}

	private function onMenuClose(event:ControllerActionListener):void {
		_menuController.close();
		_gameController.open();
	}

	private function onGameClose(event:ControllerActionListener):void {
		_gameController.close();
		_menuController.open();
	}

	private function onGameOpen(event:ControllerActionListener):void {
		_gameController.close();
		_gameController.open();
	}
		
}
}