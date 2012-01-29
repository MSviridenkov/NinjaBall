package game.matrix {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class MatrixMap {
		private static const MATRIX_WIDTH:int = 12;
		private static const MATRIX_HEIGHT:int = 11;
		
		public var stones:Vector.<Sprite>;
		
		private var _matrix:Vector.<Vector.<uint>>;
		private var _gameContainer:Sprite;
		//private var _wallBitmapData:BitmapData;
		
		public function MatrixMap(container:Sprite) {
			_gameContainer = container;
			//_wallBitmapData = new BitmapData(50, 50, false, 0xf56a78);
			//trace ("bum", _wallBitmapData.getPixel(1,1));
			createMatrix();
			traceMatrix();
			for (var i:int = 0; i < MATRIX_HEIGHT; i++) {
				for (var j:int = 0; j < MATRIX_WIDTH; j++) {
					if (_matrix[i][j] == MatrixItemIds.EMPTY) {
					}
					if (_matrix[i][j] == MatrixItemIds.STONE) {
						createStone(j, i);
					}
				}
			}
		}
		
		private function createMatrix():void {
			_matrix = new Vector.<Vector.<uint>>();
			for (var i:int = 0; i < MATRIX_HEIGHT; i++) {
				_matrix.push(new Vector.<uint>);
			}
			for each (var vect:Vector.<uint> in _matrix) {
				for (var j:int = 0; j < MATRIX_WIDTH; j++) {
					if (Math.random() <.9) { vect.push(MatrixItemIds.EMPTY); }
					else { vect.push(MatrixItemIds.STONE); }
				}
			}
		}
		
		private function createStone(x:int, y:int):void {
			var stone:Sprite = new Sprite;
			if (!stones) {stones = new Vector.<Sprite>};
			stone.x = x*50;
			stone.y = y*50;
			/*stone.graphics.beginBitmapFill(_wallBitmapData);
			stone.graphics.drawRect(0, 0, 50, 50);
			stone.graphics.endFill();*/
			stone.graphics.beginFill(0xf56a78);
			stone.graphics.drawRect(0, 0, 50, 50);
			stone.graphics.endFill();
			stones.push(stone);
			_gameContainer.addChild(stone);
		}
		
		private function traceMatrix():void {
			for each (var vect:Vector.<uint> in _matrix) {
				//trace (vect); Вывод матрицы!!!
			}
		}
	}
}