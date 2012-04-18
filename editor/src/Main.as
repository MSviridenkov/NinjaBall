package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

import model.EditorModel;

import view.EditorController;

/**
	 * NinjaBallEditor Main
	 * @author ProBigi
	 */
	[SWF(width=600, height=600, frameRate=60)]

	public class Main extends Sprite {
		public static const WIDTH:int = 600;
		public static const HEIGHT:int = 600;
		private var _panel:Boolean = false;

		public function Main():void {
			var editorController = new EditorController(new EditorModel());
			super.addChild(editorController);
		}
	}
	
}