package game {
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	public class DrawController {
		private var _ball:Sprite;
		private var _candraw:Boolean;
		private var _path:Sprite;
		private var _currentMousePoint:Point;
		private var _mousePoints:Vector.<Point>;
		private var _gameController:GameController;
		private var _enemyController:EnemyController;
		private var _drawContainer:Sprite;
		private var _gameContainer:Sprite;
		private var _moving:Boolean;
		
		public function DrawController(container:Sprite, enemyController:EnemyController) {
			_drawContainer = new Sprite;
			_gameContainer = container;
			_enemyController = enemyController;
			_moving = false;
			_candraw = false;
			_path = new Sprite;
			_mousePoints = new Vector.<Point>;
			drawBall();
			_drawContainer.addChild(_path);
			_gameContainer.addChild(_drawContainer);
			_gameContainer.addChild(_ball);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		/*Ball*/
		
		private function drawBall():void {
			_ball = new Sprite;
			_ball.graphics.beginFill(0xF567F8);
			_ball.graphics.drawCircle(0, 0, 20);
			_ball.graphics.endFill();
			_ball.x = 300;
			_ball.y = 570;
		}
		
		private function fillBall(color:int):void {
			var colorInfo:ColorTransform = new ColorTransform;
			colorInfo.color = color;
			_ball.transform.colorTransform = colorInfo;
		}
		
		private function removeBall():void {
			_moving = false;
			_gameContainer.removeChild(_ball);
			TweenMax.killTweensOf(_ball);
		}
		
		private function checkBallHitSquare():void {
			if (_ball.hitTestObject(_enemyController.square)) {
				removeBall();
			}
		}
		
		/*Mouse Functions*/
		
		
		private function onMouseDown(event:MouseEvent):void {
			if ((_ball.x - _ball.width/2) < event.stageX && event.stageX < (_ball.x + _ball.width/2) &&
				(_ball.y - _ball.height/2) < event.stageY && event.stageY < (_ball.y + _ball.height/2)) {
				_candraw = true;
				fillBall(0xFF0000);
				_enemyController.tweenSquare.pause();
			}
			_path.graphics.moveTo(event.stageX, event.stageY);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (_candraw) {
				_currentMousePoint = new Point(event.stageX, event.stageY);
				_path.graphics.lineStyle(5, 0x002FFF);
				_path.graphics.lineTo(_currentMousePoint.x, _currentMousePoint.y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_candraw = false;
			fillBall(0xF567F8);
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
			_moving = true;
			_enemyController.tweenSquare.play();
		}
		
		/*Move*/
		
		/*private function moveToPoint():void {
		if (!_mousePoints || _mousePoints.length == 0) {return; }
		const point:Point = _mousePoints[0];
		_mousePoints.shift();
		var distance:int = Math.sqrt((point.x-_ball.x)*(point.x-_ball.x) + (_ball.y - point.y)*(_ball.y - point.y));
		new TweenMax(_ball, distance/SPEED, {x : point.x, y : point.y, 
		ease : Linear.easeNone, 
		onUpdate : checkBallHitSquare(), 
		onComplete : function():void { if (_moving) { moveToPoint(); }}
		});
		}*/
		
		/*Enter Frame*/
		
		private function onEnterFrame(event:Event):void {
			if (_currentMousePoint != null) {
				_mousePoints.push(_currentMousePoint);
			}
		}
		
		private function onEnterFrameSecond(event:Event):void {
			if (!_mousePoints || _mousePoints.length == 0) {return; }
			const point:Point = _mousePoints[0];
			_mousePoints.shift();
			checkBallHitSquare();
			_ball.x = point.x;
			_ball.y = point.y;
		}
	}
}