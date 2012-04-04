package view.Trap 
{
	import flash.display.Sprite;
	/**
	 * Базовый класс ловушки
	 * @author ProBigi
	 */
	public class Trap extends Sprite
	{
		private var _type:int;
		public function Trap(type:int) 
		{
			_type = type;
		}
		
	}

}