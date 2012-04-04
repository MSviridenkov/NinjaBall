package controller 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import model.EditorModel;
	import view.EditorView;
	/**
	 * ...
	 * @author ProBigi
	 */
	public class EditorController 
	{
		private var _editroModel:EditorModel;
		private var _editorView:EditorView;
		private var _container:Stage;
		
		public function EditorController(container:Stage) {
			_container = container;
			_editroModel = new EditorModel();
			_editorView = new EditorView(_editroModel, _container);
			
			addListeners();
		}
		public function get view():view.EditorView { return _editorView; }
		private function addListeners():void {
			
		}
		
	}

}