package game {
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import game.matrix.MatrixMap;

	public class GameController {
		private var _gameContainer:Sprite;
		private var _squareController:SquareController;
		private var _crossController:CrossController;
		private var _matrixMap:MatrixMap;
		
		private var _ball:Sprite;
		private var _candraw:Boolean;
		private var _path:Sprite;
		private var _currentMousePoints:Vector.<Point>;
		private var _mousePoints:Vector.<Point>;
		private var _drawContainer:Sprite;
		private var _btm:BitmapData;
		
		const SPEED:int = 30;
		
		public function GameController(container:Sprite) {
			_gameContainer = container;
			_drawContainer = new Sprite;
			_squareController = new SquareController(_gameContainer);
			_crossController = new CrossController(_gameContainer);
			_matrixMap = new MatrixMap(_gameContainer);
			_path = new Sprite;
			_mousePoints = new Vector.<Point>;
			_currentMousePoints = new Vector.<Point>;
			_candraw = false;
			
			
			drawBall();
			drawSquareOnContainer();
			
			_drawContainer.addChild(_path);
			_gameContainer.addChild(_drawContainer);
			_gameContainer.addChild(_ball);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrameFirst);
		}
		
		private function drawSquareOnContainer():void {
			_gameContainer.graphics.beginFill(0xFFFFFF);
			_gameContainer.graphics.drawRect(0, 0, 600, 600);
			_gameContainer.graphics.endFill();
		}
		
		/*Ball*/
		
		private function drawBall():void {
			_ball = new Sprite;
			_ball.graphics.beginFill(0xF567F8);
			_ball.graphics.drawCircle(0, 0, 20);
			_ball.graphics.endFill();
			_ball.x = 300;
			_ball.y = 575;
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
				TweenMax.pauseAll(true);
				_crossController.stopCrossRot();
			}
			_path.graphics.moveTo(event.stageX, event.stageY);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			for each (var stone:Sprite in _matrixMap.stones) {
				if (_path.hitTestObject(stone)) {
					trace (true);
					_candraw = false;
				}
			}
			if (_candraw) {
				_currentMousePoints.unshift(new Point(event.stageX, event.stageY));
				_path.graphics.lineStyle(5, 0x002FFF);
				_path.graphics.lineTo(_currentMousePoints[0].x, _currentMousePoints[0].y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_candraw = false;
			fillBall(0xF567F8);
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameFirst);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
			TweenMax.resumeAll(true);
			_crossController.startCrossRot();
		}
		
		/*Enter Frame*/
		
		private function onEnterFrameFirst(event:Event):void {
			if (!_mousePoints || _currentMousePoints.length == 0 ) {return; }
			_mousePoints.push(_currentMousePoints[0]);
		}
		
		private function onEnterFrameSecond(event:Event):void {
			if (!_mousePoints || _mousePoints.length == 0) {return; }
			const point:Point = _mousePoints[0];
			_mousePoints.shift();
			_ball.x = point.x;
			_ball.y = point.y;
			checkObjectsHitSquare(new Point(_ball.x, _ball.y));
		}
		
		/*Functions*/
		
		private function checkObjectsHitSquare(ballpoint:Point):void {
			for each (var square:Sprite in _squareController.squares) {
				if (_ball.hitTestObject(square) == true) {
					_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
					_gameContainer.removeChild(_ball); //удаляет шарик
					_gameContainer.removeChild(_drawContainer); //удаляет линию
				}
			}
			
			var point:Point = ballpoint;
			var num:int = (Math.SQRT2)/2*10;
			for each (var cross:Sprite in _crossController.crosses) {
				if (cross.hitTestPoint(point.x+10, point.y+10, true) == true ||//П/2
					cross.hitTestPoint(point.x+10, point.y-10, true) == true ||
					cross.hitTestPoint(point.x-10, point.y+10, true) == true ||
					cross.hitTestPoint(point.x-10, point.y-10, true) == true 
					//cross.hitTestPoint(point.x+num, point.y+num, true) == true ||//П/4
					//cross.hitTestPoint(point.x+num, point.y-num, true) == true ||
					//cross.hitTestPoint(point.x-num, point.y+num, true) == true ||
					/*cross.hitTestPoint(point.x-num, point.y-num, true) == true*/) {
					_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
					_gameContainer.removeChild(_ball); //удаляет шарик
					_gameContainer.removeChild(_drawContainer); //удаляет линию
				}
			}
			
			/*for each (var stone:Sprite in _matrixMap.stones) {
				if (_ball.hitTestObject(stone)) {
					_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
					_gameContainer.removeChild(_ball); //удаляет шарик
					_gameContainer.removeChild(_drawContainer); //удаляет линию
				}
			}*/
		}
		
		public function removeSecondListener():void {
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameSecond);
		}
		
		private function moveToPoint():void {
		/*if (!_mousePoints || _mousePoints.length == 0) {return; }
		const point:Point = _mousePoints[0];
		_mousePoints.shift();
		var distance:int = Math.sqrt((point.x-_ball.x)*(point.x-_ball.x) + (_ball.y - point.y)*(_ball.y - point.y));
		new TweenMax(_ball, distance/SPEED, {x : point.x, y : point.y, 
		ease : Linear.easeNone, 
		onUpdate : checkBallHitSquare(), 
		onComplete : function():void { if (_moving) { moveToPoint(); }}
		});*/
		}
	}
}

/*for each (var stone:Sprite in _matrixMap.stones) {
if (event.stageX <= stone.x ||
event.stageX >= stone.x + 50 ||
event.stageY <= stone.y ||
event.stageY >= stone.y + 50) {}
else {
//_bools.push(false);
_candraw2 = false;
//_path.graphics.moveTo(300, 300);
}
if (event.stageX == stone.x && event.stageY < stone.y + 50 && event.stageY > stone.y) {trace("1"); _stena1 = false} // Мышка на 1
if (event.stageY == stone.y + 50 && event.stageX < stone.x + 50 && event.stageX > stone.x) {trace("2");} // Мышка на 2
if (event.stageX == stone.x + 50 && event.stageY < stone.y + 50 && event.stageY > stone.y) {trace("3");} // Мышка на 3
if (event.stageY == stone.y && event.stageX < stone.x + 50 && event.stageX > stone.x) {trace("4");} // Мышка на 4

}*/

/*trace (event.stageX, event.stageY);
for each (var stone:Sprite in _matrixMap.stones) {
if (event.stageX < stone.x ||
event.stageX > stone.x + 50 ||
event.stageY < stone.y ||
event.stageY > stone.y + 50) {_bools.push(false)}
else {_bools.push(true)}
}
if (_bools.indexOf(true) == -1) {
_currentMousePoint = new Point(event.stageX, event.stageY);
_bools.splice(0, _bools.length);
}
trace (_bools);*/

//trace (_currentMousePoints);
//trace (_currentMousePoints[0]);
//trace (_currentMousePoints[0]);
/*for each (var stone:Sprite in _matrixMap.stones) {
var S:Point = new Point(stone.x, stone.y);
var D:Point = new Point(stone.x, stone.y + 50);
var E:Point = new Point(stone.x + 50, stone.y);
var F:Point = new Point(stone.x + 50, stone.y + 50);

1-1
if (_currentMousePoints.length > 2 &&
_currentMousePoints[1].x <= S.x &&
_currentMousePoints[1].x > S.x - 5 &&
_currentMousePoints[1].y < S.y + 50 &&
_currentMousePoints[1].y > S.y &&
_currentMousePoints[0].y < S.y + 52.5 &&
_currentMousePoints[0].y > S.y + 47.5 &&
_currentMousePoints[0].x < S.x + 50 &&
_currentMousePoints[0].x > S.x) {
_currentMousePoints.splice(1, 0, D); trace (_currentMousePoints);

}
1-3
if (_currentMousePoints.length > 2 &&
_currentMousePoints[1].x <= stone.x &&
_currentMousePoints[1].x > stone.x - 5 &&
_currentMousePoints[1].y < stone.y + 50 &&
_currentMousePoints[1].y > stone.y &&
_currentMousePoints[0].y < stone.y + 50 &&
_currentMousePoints[0].y > stone.y &&
_currentMousePoints[0].x < stone.x + 52.5 &&
_currentMousePoints[0].x >= stone.x + 47.5) {
if ((_currentMousePoints[1].y - stone.y) + 50 + (_currentMousePoints[0].y - stone.y) >
(stone.y + 50 - _currentMousePoints[1].y) + 50 + (stone.y + 50 - _currentMousePoints[0].y)) {		//Проверка длинны
_path.graphics.lineTo(D.x, D.y);
_path.graphics.lineTo(F.x, F.y);
for (var i:int = 1; i <= SPEED; i++) {
_mousePoints.push(new Point(_currentMousePoints[1].x, _currentMousePoints[1].y + (D.y - _currentMousePoints[1].y)*1));
trace (_mousePoints);
}
_mousePoints.push(new Point(D.x, D.y));
_mousePoints.push(new Point(F.x, F.y));
//trace (_currentMousePoints);
}
else {
_path.graphics.lineTo(S.x, S.y);
_path.graphics.lineTo(E.x, E.y);
_mousePoints.push(new Point(S.x, S.y));
_mousePoints.push(new Point(E.x, E.y));
}
}
}*/