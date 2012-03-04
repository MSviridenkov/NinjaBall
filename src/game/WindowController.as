package game {
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.EaseLookup;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.RemoveTintPlugin;
	
	import flash.display.Sprite;

	public class WindowController {
		private var _gameContainer:Sprite;
		private var _window:Sprite;
		
		public function WindowController(container:Sprite) {
			_gameContainer = container;
			const windowView:WindowView = new WindowView();
			_window = new Sprite();
			_window.addChild(windowView);
			_gameContainer.addChild(_window);
			_window.x = 300;
			_window.y = 0;
			tweenWindow();
		}
		
		private function tweenWindow():void {
			TweenMax.to(_window, 0.75, {x: 300, y: 275, ease: Back.easeOut});
		}
	}
}