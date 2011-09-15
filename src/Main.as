package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.debugger.enterDebugger;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import game.EnemyController;
	
	[SWF(width=600, height=600, frameRate=25)]
	
	public class Main extends Sprite {
		public var container:Sprite;
		private var _ball:Sprite;
		private var _candraw:Boolean;
		private var _path:Sprite;
		private var _pathPoints:Vector.<Point>;
		private var _currentMousePoint:Point;
		private var _mousePoints:Vector.<Point>;
		private var _enemyController:EnemyController;
		
		private var _moving:Boolean;
		
		private static const SPEED:int = 80;
		
		public function Main() {
			_moving = false;
			_candraw = false;
			_path = new Sprite;
			_pathPoints = new Vector.<Point>;
			_mousePoints = new Vector.<Point>;
			_enemyController = new EnemyController;
			drawBall();
			stage.addChild(_ball);
			stage.addChild(_enemyController.square);
			stage.addChild(_path);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
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
			stage.removeChild(_ball);
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
				_pathPoints.push(_currentMousePoint);
				_path.graphics.lineStyle(5, 0x002FFF);
				_path.graphics.lineTo(_currentMousePoint.x, _currentMousePoint.y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_candraw = false;
			fillBall(0xF567F8);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
			_moving = true;
			_enemyController.tweenSquare.play();
		}
		
		/*Move*/
		
		private function moveToPoint():void {
			if (!_mousePoints || _mousePoints.length == 0) {return; }
			const point:Point = _mousePoints[0];
			_mousePoints.shift();
			var distance:int = Math.sqrt((point.x-_ball.x)*(point.x-_ball.x) + (_ball.y - point.y)*(_ball.y - point.y));
			new TweenMax(_ball, distance/SPEED, {x : point.x, y : point.y, 
				ease : Linear.easeNone, 
				onUpdate : checkBallHitSquare(), 
				onComplete : function():void { if (_moving) { moveToPoint(); }}
			});
		}
		
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
			_ball.x = point.x;
			_ball.y = point.y;
		}
	}
}