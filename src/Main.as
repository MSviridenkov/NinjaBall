package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width=600, height=600, frameRate=25)]
	
	public class Main extends Sprite {
		public var container:Sprite;
		private var _ball:Shape;
		private var _candraw:Boolean;
		private var _currentPartPath:Shape;
		private var _currentMousePoint:Point;
		
		public function Main() {
			container = new Sprite;
			_candraw = false;
			_currentPartPath = new Shape;
			drawBall();
			container.addChild(_ball);
			container.addChild(_currentPartPath);
			this.addChild(container);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function drawBall():void {
			_ball = new Shape;
			_ball.graphics.beginFill(0xf567f8);
			_ball.graphics.drawCircle(300, 570, 20);
			_ball.graphics.endFill();
		}
		
		private function onMouseDown(event:MouseEvent):void {
			_candraw = true;
			_currentPartPath.graphics.moveTo(event.stageX, event.stageY)
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (_candraw) {
				_currentPartPath.graphics.lineTo(event.stageX, event.stageY);
				_currentPartPath.graphics.lineStyle(5, 0x002FFF);
				trace (_currentPartPath.x, _currentPartPath.y, event.stageX, event.stageY);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_candraw = false;
		}
	}
}