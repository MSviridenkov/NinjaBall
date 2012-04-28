package game {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
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
	
	import mochi.as3.MochiDigits;
	import mochi.as3.MochiScores;
	
	import mx.events.MoveEvent;
	
	import rpc.GameRpc;

public class GameController extends EventDispatcher implements IController {
		var o:Object = { n: [4, 6, 13, 10, 2, 12, 9, 8, 8, 1, 12, 6, 5, 4, 7, 4], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
		var boardID:String = o.f(0,"");

		private var _gameContainer:Sprite;
		private var _squareController:SquareController;
		private var _crossController:CrossController;
		//private var _matrixMap:MatrixMap;
		private var _windowController:WindowController;
		
		private var _ball:Sprite;
		private var _canAddPoints:Boolean;
		private var _gameState:uint;
		private var _path:Sprite;
		private var _finishSquare:Sprite;
		//private var _currentMousePoints:Vector.<Point>;
		private var _mousePoints:Vector.<Point>;
		private var _drawContainer:Sprite;
		private var _endWindow:Sprite;
		private var _feedbackSent:Boolean = false;
		private var _walls:Sprite;
		private var _drawingController:DrawingController;

		private var _win:Boolean;

		private var _gameStartTime:Number;

		private const STATE_MOVE:uint = 0;
		private const STATE_DRAW:uint = 1;
		private const STATE_STOP:uint = 2;
		private const BALL_SPEED:Number = 70;

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
			_gameStartTime = new Date().getTime();
			_drawingController.addListeners();
			_mousePoints = new Vector.<Point>;
			//_currentMousePoints = new Vector.<Point>;
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
			_canAddPoints = false;
		}

		public function close():void {
			_drawingController.removeListeners();
			_drawingController.clear();
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
				_canAddPoints = true;
				pauseGame();
			}
			_path.graphics.moveTo(event.stageX, event.stageY);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			var point = new Point(event.stageX, event.stageY);
			if (_canAddPoints) {
				if (!_mousePoints) {return; }
				_mousePoints.push(point);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if (_gameState == STATE_STOP || _canAddPoints == false) { return; }
			_canAddPoints = false;
			_gameState = STATE_MOVE;
			resumeGame();
			moving();
			
			if (_gameState == STATE_MOVE) {
				if (!_mousePoints || _mousePoints.length == 0) {
					openEndWindow(false);
					return;
				}
			}
		}
		
		/*Enter Frame*/
		
		private function onEnterFrame(event:Event):void {
			if (_gameState == STATE_DRAW) {
				if (_mousePoints.length == 0) {return; }
				_drawingController.drawPathToCurrentPoint(_mousePoints[_mousePoints.length-1]);
				//trace (_mousePoints);
			}
			if (_gameState == STATE_MOVE) {
				if (checkObjectsHitBall(new Point(_ball.x, _ball.y))) {
					openEndWindow(false);
				} else if (checkForFinish()) {
					openEndWindow(true);
				}
			}
			/*if (_gameState == "stop") {
				pauseGame();
			}*/
		}
		
		/*Functions*/
		
		private function moving():void {
			if (_mousePoints.length !== 0) {
				var point:Point = _mousePoints.shift();
				var distation:Number = Math.sqrt((point.x-_ball.x)*(point.x-_ball.x) + (point.y-_ball.y)*(point.y-_ball.y));
				var time:Number = distation/BALL_SPEED;
				TweenMax.to(_ball, time, {x: point.x, y: point.y, ease: Linear.easeNone, onComplete: function():void { moving(); trace(point); _drawingController.removePathPartByMousePoint(point);}});
			}
		}
		
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
			_canAddPoints = false;

			_endWindow = createEndWindow(win);
			//_endWindow.addChild(createTextField(win ? "you win" : "you lose", -20, -5));
			_gameContainer.addChild(_endWindow);
		}

		private function createEndWindow(win:Boolean):Sprite {
			var result:Sprite;
			if (!_feedbackSent) {
				_feedbackSent = true;
				var gameResult:Sprite = win ? new WinWindowView() : new LoseWindowView();
				var feedback:FeedBack = new FeedBack();
				feedback.x = Main.WIDTH/2-feedback.width/2;
				feedback.y = Main.HEIGHT/2-feedback.height/2;
				gameResult.x =  feedback.width/2;
				feedback.addChild(gameResult);
				feedback.sendBtn.addEventListener(MouseEvent.CLICK, onFeedbackSendClick);
				feedback.closeBtn.addEventListener(MouseEvent.CLICK, onFeedbackCloseClick);
				result = feedback;
			} else {
				result = win ? new WinWindowView() : new LoseWindowView();
				result.x = Main.WIDTH/2;
				result.y = Main.HEIGHT/2;
				result.addEventListener(MouseEvent.CLICK, onEndWindowClick);
			}
			return result;
		}

		private function onFeedbackCloseClick(event:MouseEvent):void {
			_endWindow.removeEventListener(MouseEvent.CLICK, onFeedbackCloseClick);
			_endWindow.removeEventListener(MouseEvent.CLICK, onFeedbackSendClick);
			closeEndWindowAndOpenMochi();
		}
		private function onFeedbackSendClick(event:MouseEvent):void {
			_endWindow.removeEventListener(MouseEvent.CLICK, onFeedbackCloseClick);
			_endWindow.removeEventListener(MouseEvent.CLICK, onFeedbackSendClick);
			var feedbackWindow:FeedBack = _endWindow as FeedBack;
			if (feedbackWindow.feedBack != "") {
				 GameRpc.instance.send({ninja_request : "save_feedback", feedback : feedbackWindow.feedBack});
			}
			closeEndWindowAndOpenMochi();
		}

		private function onEndWindowClick(event:MouseEvent):void {
			trace("end window click");
			_endWindow.removeEventListener(MouseEvent.CLICK, onEndWindowClick);
			closeEndWindowAndOpenMochi();
			//endGame();
		}

		private function closeEndWindowAndOpenMochi():void {
			_gameContainer.removeChild(_endWindow);
			var scoreMilliseconds:int = new Date().getTime() - _gameStartTime;
			trace("score milliseconds : " + scoreMilliseconds);

			if (Main.MOCHI_ON && _win) {
				var mochiScore:MochiDigits = new MochiDigits();
				mochiScore.value = scoreMilliseconds/1000.;
				MochiScores.showLeaderboard({
					boardID: boardID,
					score: mochiScore.value,
					onClose: endGame()
				});
			} else { endGame(); }
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