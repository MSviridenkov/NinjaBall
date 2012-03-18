package game {
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import game.event.ControllerActionListener;

import game.matrix.MatrixMap;

	public class GameController extends EventDispatcher implements IController {
		private var _gameContainer:Sprite;
		private var _squareController:SquareController;
		private var _crossController:CrossController;
		//private var _matrixMap:MatrixMap;
		private var _windowController:WindowController;
		
		private var _ball:Sprite;
		private var _canDraw:Boolean;
		private var _gameState:uint;
		private var _path:Sprite;
		private var _finishSquare:Sprite;
		private var _currentMousePoints:Vector.<Point>;
		private var _mousePoints:Vector.<Point>;
		private var _drawContainer:Sprite;
		private var _endWindow:Sprite;
		private var _walls:Sprite;
		private var _drawingController:DrawingController;

		private var _win:Boolean;

		private const STATE_MOVE:uint = 0;
		private const STATE_DRAW:uint = 1;
		private const STATE_STOP:uint = 2;

		public function GameController(container:Sprite) {
			_gameContainer = container;
			_drawContainer = new Sprite();
			_ball = createBall();
			_drawingController = new DrawingController(_gameContainer, _ball);
			_walls = createWalls();
			_finishSquare = createFinishSquare()
		}

		private function drawSquareOnContainer():void {
			_gameContainer.graphics.beginFill(0xFFFFFF);
			_gameContainer.graphics.drawRect(0, 0, 600, 600);
			_gameContainer.graphics.endFill();
		}

		public function open():void {
			_drawingController.addListeners();
			_mousePoints = new Vector.<Point>;
			_currentMousePoints = new Vector.<Point>;
			_squareController = new SquareController(_gameContainer);
			_crossController = new CrossController(_gameContainer);
			drawSquareOnContainer();
			_path = new Sprite();
			_drawContainer.addChild(_path);
			_gameContainer.addChild(_drawContainer);
			_ball.x = 300;
			_ball.y = Main.HEIGHT - _ball.height;
			_gameContainer.addChild(_ball);
			_finishSquare.x = int(Math.random() * 400);
			_gameContainer.addChild(_finishSquare);
			_gameContainer.addChild(_walls);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_gameContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_gameState = STATE_DRAW;
			_canDraw = false;
		}

		public function close():void {
			_drawingController.removeListeners();
			_drawingController.removeAllParts();
			_squareController.remove();
			_crossController.remove();
			if (_drawContainer.contains(_path)) { _drawContainer.removeChild(_path); }
			if (_gameContainer.contains(_drawContainer)) { _gameContainer.removeChild(_drawContainer); }
			if (_gameContainer.contains(_ball)) { _gameContainer.removeChild(_ball); }
			if (_gameContainer.contains(_finishSquare)) { _gameContainer.removeChild(_finishSquare); }
			if (_gameContainer.contains(_walls)) { _gameContainer.removeChild(_walls); }
			_gameContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameContainer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_gameContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function createFinishSquare():Sprite {
			var result:Sprite = new Sprite();
			result.graphics.beginFill(0x000000, .3);
			result.graphics.drawRect(0, 0, 100, 20);
			result.graphics.endFill();
			result.addChild(createTextField("FINISH", 30, 0));
			result.y = 10;
			return result;
		}

		private function createBall():Sprite {
			var result:Sprite = new BallView();
			return result;
		}

		private function createWalls():Sprite {
			var result:Sprite = new Sprite();
			var wall:WallView = new WallView();
			result.addChild(wall);
			wall = new WallView();
			wall.x = wall.height-2;
			wall.rotation = 90;
			result.addChild(wall);
			wall = new WallView();
			wall.x = Main.WIDTH;
			wall.rotation = 90;
			result.addChild(wall);
			wall = new WallView();
			wall.y = Main.HEIGHT - wall.height;
			result.addChild(wall);
			
			return result;
		}
		
		/*Mouse Functions*/
		
		private function onMouseDown(event:MouseEvent):void {
			if ((_ball.x - _ball.width/2) < event.stageX && event.stageX < (_ball.x + _ball.width/2) &&
				(_ball.y - _ball.height/2) < event.stageY && event.stageY < (_ball.y + _ball.height/2)) {
				_canDraw = true;
				pauseGame();
			}
			_path.graphics.moveTo(event.stageX, event.stageY);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			//for each (var stone:Sprite in _matrixMap.stones) {
			//	if (_path.hitTestObject(stone)) {
			//	}
			//}
			if (_canDraw) {
				_currentMousePoints.unshift(new Point(event.stageX, event.stageY));
				//_path.graphics.lineStyle(5, 0x002FFF);
				//_path.graphics.lineTo(_currentMousePoints[0].x, _currentMousePoints[0].y);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if (_gameState == STATE_STOP || _canDraw == false) { return; }
			_canDraw = false;
			_gameState = STATE_MOVE;
			resumeGame();
		}
		
		/*Enter Frame*/
		
		private function onEnterFrame(event:Event):void {
			if (_gameState == STATE_DRAW) {
				if (!_mousePoints || _currentMousePoints.length == 0 ) {return; }
				_mousePoints.push(_currentMousePoints[0]);
			}
			if (_gameState == STATE_MOVE) {
				if (!_mousePoints || _mousePoints.length == 0) {
					openEndWindow(false);
					return;
				}
				//_drawingController.removePointsAroundNinja();
				const point:Point = _mousePoints[0];
				_mousePoints.shift();
				_ball.x = point.x;
				_ball.y = point.y;
				if (checkObjectsHitBall(new Point(_ball.x, _ball.y))) {
					openEndWindow(false);
				}
				if (checkForFinish()) {
					openEndWindow(true);
				}
			}
			/*if (_gameState == "stop") {
				pauseGame();
			}*/
		}
		
		/*Functions*/
		
		private function addWindow():void {
			_windowController = new WindowController(_gameContainer);
		}
			
		private function pauseGame():void {
			TweenMax.pauseAll(true);
			_crossController.stopCrossRot();
		}
		
		private function resumeGame():void {
			TweenMax.resumeAll(true);
			_crossController.startCrossRot();
		}

		private function openEndWindow(win:Boolean):void {
			_win = win;
			_gameState = STATE_STOP;
			_canDraw = false;

			_endWindow = createEndWindow(win);
			//_endWindow.addChild(createTextField(win ? "you win" : "you lose", -20, -5));
			_endWindow.addEventListener(MouseEvent.CLICK, onEndWindowClick);
			_gameContainer.addChild(_endWindow);
		}

		private function createEndWindow(win:Boolean):Sprite {
			var result:Sprite = win ? new WinWindowView() : new LoseWindowView();
			result.x = Main.WIDTH/2;
			result.y = Main.HEIGHT/2;
			return result;
		}

		private function onEndWindowClick(event:MouseEvent):void {
			trace("end window click");
			_endWindow.removeEventListener(MouseEvent.CLICK, onEndWindowClick);
			_gameContainer.removeChild(_endWindow);
			endGame();
		}

		private function createTextField(text:String, x:Number, y:Number):TextField {
			var result:TextField = new TextField();
			result.mouseEnabled = false;
			result.selectable = false;
			result.text = text;
			result.autoSize = TextFieldAutoSize.LEFT;
			result.x = x;
			result.y = y;
			return result;
		}

		private function endGame():void {
			_win ?
					dispatchEvent(new ControllerActionListener(ControllerActionListener.OPEN))
					:
					dispatchEvent(new ControllerActionListener(ControllerActionListener.CLOSE));
		}
		
		private function checkObjectsHitBall(point:Point):Boolean {
			return (checkSquares(point) || checkCrossesHitBall(point));
		}

		private function checkSquares(point:Point):Boolean {
			var result:Boolean = false;
			for each (var square:Sprite in _squareController.squares) {
				if (_ball.hitTestObject(square) == true) {
					result = true;
				}
			}
			return result;
		}

		private function checkCrossesHitBall(point:Point):Boolean {
			var result:Boolean = false;
			for each (var cross:Sprite in _crossController.crosses) {
				if (cross.hitTestPoint(point.x + _ball.width/2, point.y + _ball.height/2, true) == true ||
						cross.hitTestPoint(point.x + _ball.width/2, point.y - _ball.height/2, true) == true ||
							cross.hitTestPoint(point.x - _ball.width/2, point.y + _ball.height/2, true) == true ||
								cross.hitTestPoint(point.x -_ball.width/2, point.y - _ball.height/2, true) == true) {

					result = true;
				}
			}
			return result;
		}

		private function checkForFinish():Boolean {
			return (_ball.hitTestObject(_finishSquare));
		}

	}
}