package view 
{
	import fl.controls.Button;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import model.EditorModel;
	import view.cell.Cell;
import view.panel.ItemsPanel;
import view.panel.OptionsPanel;

/**
	 * ...
	 * @author ProBigi
	 */
	public class EditorView extends Sprite implements IObjectController
	{
		private var _model:EditorModel;
		private var _container:Stage;
		private var _grid:Sprite;
		private var _cells:Vector.<Cell>;
		private var _itemsPanel:ItemsPanel;
		private var _optionsPanel:OptionsPanel;
		public function EditorView(model:model.EditorModel, container:Stage) {
			_model = model;
			_container = container;
			init();
		}

		public function init():void {
			createGrid();
			createItemsPanel();
			createOptionsPanel();
			addListeners();
		}
		public function clear():void {
			removeListeners();
			var len:int = this.numChildren;
			while (len > 0) { this.removeChildAt(0); len--; }
		}
		private function addListeners():void {
			_container.addEventListener(KeyboardEvent.KEY_DOWN, onShowItems);
			_container.addEventListener(KeyboardEvent.KEY_DOWN, onShowOptions);
			_itemsPanel.cancelBtn.addEventListener(MouseEvent.CLICK, onCloseItems);
		}
		
		
		
		private function removeListeners():void {
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, onShowItems);
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, onShowOptions);
			_itemsPanel.cancelBtn.removeEventListener(MouseEvent.CLICK, onCloseItems);
		}
		private function createGrid():void {
			_grid = new Sprite;
			_cells = new Vector.<Cell>;
			for (var i:int = 0; i < 30; i++) {
				for (var j:int = 0; j < 30; j++)
				{
					var cell:Cell = new Cell(i, j);
					cell.x = 20 * j;
					cell.y = 20 * i;
					_cells.push(cell);
					_grid.addChild(cell);
				}
			}
			this.addChild(_grid);
		}
		private function createItemsPanel():void {
			_itemsPanel = new ItemsPanel;
			_itemsPanel.visible = false;
			this.addChild(_itemsPanel);
		}
		private function createOptionsPanel():void {
			_optionsPanel = new OptionsPanel;
			_optionsPanel.visible = false;
			this.addChild(_optionsPanel);
		}
		private function onShowItems(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				if (_itemsPanel.visible) { _itemsPanel.visible = false; }
				else { _itemsPanel.visible = true; }
			}
		}
		private function onCloseItems(e:MouseEvent):void {
			if (_itemsPanel.visible) { _itemsPanel.visible = false; }
		}
		private function onShowOptions(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SHIFT) {
				if (_optionsPanel.visible) { _optionsPanel.visible = false; }
				else { _optionsPanel.visible = true; }
			}
		}
	}
}