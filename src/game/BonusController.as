package game {
	import flash.display.Sprite;
	
	import flashx.textLayout.elements.SpecialCharacterElement;

	public class BonusController {
		
		private var _gameContainer:Sprite;
		public var speedBonusVector:Vector.<Sprite>;
		
		public function BonusController(container:Sprite) {
			_gameContainer = container;
			createSpeedBonuses();
		}
		
		private function createSpeedBonuses():void {
			speedBonusVector = new Vector.<Sprite>();
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
		}
	}
}