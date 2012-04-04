package 
{
	import controller.EditorController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * NinjaBallEditor Main
	 * @author ProBigi
	 */
	[SWF(width=600, height=600, frameRate=60)]

	public class Main extends Sprite
	{
		public static const WIDTH:int = 600;
		public static const HEIGHT:int = 600;
		private var _editorController:EditorController;
		private var _panel:Boolean = false;
		public function Main():void {
			_editorController = new EditorController(stage);
			super.addChild(_editorController.view);
		}
	}
	
}