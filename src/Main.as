package {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
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
		private var _enemyController:EnemyController;
		private static const SPEED:int = 40;
		
		public function Main() {
			_candraw = false;
			_path = new Sprite;
			_pathPoints = new Vector.<Point>;
			_enemyController = new EnemyController;
			drawBall();
			stage.addChild(_ball);
			stage.addChild(_enemyController.square);
			stage.addChild(_path);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/*Ball*/
		
		private function drawBall():void {
			_ball = new Sprite;
			_ball.graphics.beginFill(0xF567F8);
			_ball.graphics.drawCircle(0, 0, 20);
			_ball.graphics.endFill();
			_ball.x = 300;
			_ball.y = 570;
			_pathPoints.push (new Point(_ball.x, _ball.y));
		}
		
		private function fillBall(color:int):void {
			var colorInfo:ColorTransform = new ColorTransform;
			colorInfo.color = color;
			_ball.transform.colorTransform = colorInfo;
		}
		
		/*Mouse Functions*/
		
		private function onMouseDown(event:MouseEvent):void {
			if ((_ball.x - _ball.width/2) < event.stageX && event.stageX < (_ball.x + _ball.width/2) &&
					(_ball.y - _ball.height/2) < event.stageY && event.stageY < (_ball.y + _ball.height/2)) {
				_candraw = true;
				fillBall(0xFF0000);
			}
			_path.graphics.moveTo(event.stageX, event.stageY);
			_pathPoints.push(new Point(event.stageX, event.stageY));
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (_candraw) {
				_currentMousePoint = new Point;
				_currentMousePoint.x = event.stageX;
				_currentMousePoint.y = event.stageY;
				_pathPoints.push(_currentMousePoint);
				_path.graphics.lineStyle(5, 0x002FFF);
				_path.graphics.lineTo(_currentMousePoint.x, _currentMousePoint.y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_candraw = false;
			fillBall(0xF567F8);
			moveToPoint(new Point(_ball.x, _ball.y));
		}
		
		/*Move*/
		
		private function moveToPoint(point:Point):void {
			var distance:int = Math.sqrt((point.x-_ball.x)*(point.x-_ball.x) + (_ball.y - point.y)*(_ball.y - point.y));
			TweenMax.to(_ball, distance/SPEED, {x : point.x, y : point.y, ease : Linear.easeNone, onComplete : 
															function():void {
																var index:int = _pathPoints.indexOf(point);
																if (index < _pathPoints.length-1) {
																	moveToPoint(_pathPoints[index+1]);
																}
															}
			})
		}
	}
}