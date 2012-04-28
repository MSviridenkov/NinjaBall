package game {
	import flash.display.Sprite;
	
	import flashx.textLayout.elements.SpecialCharacterElement;

	public class BonusController {
		
		private var _gameContainer:Sprite;
		public var speedBonusVector:Vector.<Sprite>;
		public var scaleBonusVector:Vector.<Sprite>;
		
		public function BonusController(container:Sprite) {
			_gameContainer = container;
			createBonuses();
		}
		
		private function createBonuses():void {
			speedBonusVector = new Vector.<Sprite>();
			scaleBonusVector = new Vector.<Sprite>();
			for (var i:int; i < Math.random()*2; i++) {
				var speedBonus:Sprite = new Sprite();
				speedBonus.graphics.beginFill(0x1234ab);
				speedBonus.graphics.drawCircle(0,0,10);
				speedBonus.graphics.endFill();
				speedBonus.x = Math.random()*500 + 50;
				speedBonus.y = Math.random()*500 + 50;
				speedBonusVector.push(speedBonus);
				_gameContainer.addChild(speedBonus);
			}
			for (var j:int; j < Math.random()*2; j++) {
				var scaleBonus:Sprite = new Sprite();
				scaleBonus.graphics.beginFill(0xab3412);
				scaleBonus.graphics.drawCircle(0,0,10);
				scaleBonus.graphics.endFill();
				scaleBonus.x = Math.random()*500 + 50;
				scaleBonus.y = Math.random()*500 + 50;
				scaleBonusVector.push(scaleBonus);
				_gameContainer.addChild(scaleBonus);
			}
		}
		
		public function remove():void {
			for each (var speed:Sprite in speedBonusVector) {
				if (_gameContainer.contains(speed)) {_gameContainer.removeChild(speed)}
			}
			for each (var scale:Sprite in scaleBonusVector) {
				if (_gameContainer.contains(scale)) {_gameContainer.removeChild(scale)}
			}
		}
	}
}