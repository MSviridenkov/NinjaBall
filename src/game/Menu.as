package game {
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import game.event.ControllerActionListener;

public class Menu extends EventDispatcher implements IController {
	private var _gameContainer:Sprite;
	private var _menuContainer:Sprite;
	private var _startButton:StartButtonView;

	private const GLOW_FILTER:GlowFilter = new GlowFilter(0x000000, .5);

	public function Menu(container:Sprite) {
		_gameContainer = container;
		_menuContainer = new Sprite();
		_startButton = new StartButtonView();
		_startButton.gameTxt.text = "START";
		var menuView:MenuView = new MenuView();
		menuView.x = Main.WIDTH/2;
		menuView.y = Main.HEIGHT/2 - 100;
		_menuContainer.addChild(menuView);
		_menuContainer.addChild(_startButton);
		_startButton.addEventListener(MouseEvent.CLICK, onMouseClick);
		_startButton.addEventListener(MouseEvent.MOUSE_OVER, onStartMouseOver);
		_startButton.addEventListener(MouseEvent.MOUSE_OUT, onStartMouseOut);
		_startButton.x = Main.WIDTH/2;
		_startButton.y = Main.HEIGHT/1.3;
	}

	public function open():void {
		_gameContainer.addChild(_menuContainer);
	}

	public function close():void {
		_gameContainer.removeChild(_menuContainer);
	}

	private function onMouseClick(event:MouseEvent):void {
		dispatchEvent(new ControllerActionListener(ControllerActionListener.CLOSE));
	}

	private function onStartMouseOver(event:MouseEvent):void {
		_startButton.filters = [GLOW_FILTER];
	}
	private function onStartMouseOut(event:MouseEvent):void {
		_startButton.filters = [];
	}

	public function removeMenu():void {
		_gameContainer.removeChild(_menuContainer);
	}
}
}