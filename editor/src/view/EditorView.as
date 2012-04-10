package view 
{
	import events.ItemPanelEvent;
	import fl.controls.Button;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import model.EditorModel;
	import model.IDItems;
	import view.cell.Cell;
import view.obstacle.ObstacleItem;
import view.obstacle.PathPart;
import view.obstacle.SquareObstacle;
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
		private var _pathContainer:Sprite;
		private var _cells:Vector.<Cell>;
		private var _items:Vector.<ObstacleItem>;
		private var _selectedItem:ObstacleItem;
		private var _itemsPanel:ItemsPanel;
		private var _optionsPanel:OptionsPanel;
		
		private const CELL_WIDTH:int = 20;
		private const CELLS_NUM:int = 30;
		private const SELECTED_OBSTACLE_FILTERS:Array = [new GlowFilter(0)];
		
		public function EditorView(model:model.EditorModel, container:Stage) {
			_model = model;
			_container = container;
			_pathContainer = new Sprite();
			init();
		}

		public function init():void {
			createGrid();
			this.addChild(_pathContainer);
			createItemsPanel();
			createOptionsPanel();
			addListeners();
		}
		public function clear():void {
			removeListeners();
			this.removeChild(_pathContainer);
			var len:int = this.numChildren;
			while (len > 0) { this.removeChildAt(0); len--; }
		}
		private function addListeners():void {
			_container.addEventListener(KeyboardEvent.KEY_DOWN, onShowItems);
			_container.addEventListener(KeyboardEvent.KEY_DOWN, onShowOptions);
			_itemsPanel.cancelBtn.addEventListener(MouseEvent.CLICK, onCloseItems);
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function removeListeners():void {
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, onShowItems);
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, onShowOptions);
			_itemsPanel.cancelBtn.removeEventListener(MouseEvent.CLICK, onCloseItems);
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createGrid():void {
			_grid = new Sprite();
			_cells = new Vector.<Cell>();
			for (var i:int = 0; i < CELLS_NUM; i++) {
				for (var j:int = 0; j < CELLS_NUM; j++)
				{
					var cell:Cell = new Cell(i, j);
					cell.addEventListener(MouseEvent.CLICK, onCellClick);
					cell.x = CELL_WIDTH * j;
					cell.y = CELL_WIDTH * i;
					_cells.push(cell);
					_grid.addChild(cell);
				}
			}
			this.addChild(_grid);
		}
		
		private function onCellClick(event:MouseEvent):void {
				if (_selectedItem && _selectedItem.type == IDItems.CUBE) {
					var selectedItem:SquareObstacle = _selectedItem as SquareObstacle;
					var fromPoint:Point;
					var cell:Cell = event.target as Cell;
					if (selectedItem.getLastPathPart()) {
						fromPoint = new Point(selectedItem.getLastPathPart().movePoint.x,
																	selectedItem.getLastPathPart().movePoint.y);
					} else {
						fromPoint = new Point(selectedItem.x, selectedItem.y);
					}
					var pathPart:PathPart = new PathPart(fromPoint, new Point(cell.x + cell.width / 2, cell.y + cell.height / 2));
					selectedItem.addPathPart(pathPart);
					_pathContainer.addChild(pathPart.weight);
					_pathContainer.addChild(pathPart.movePoint);
					if (selectedItem.getLastPathPart) {
						_pathContainer.addChild(selectedItem.getLastPathPart().movePoint);
					}
				}
		}
		
		private function createItemsPanel():void {
			_itemsPanel = new ItemsPanel;
			_itemsPanel.visible = false;
			_itemsPanel.addEventListener(ItemPanelEvent.ADD_ITEM, onAddItemFromItemsPanel);
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
		
		private function onEnterFrame(event:Event):void {
				if (_selectedItem) {
					_selectedItem.x = (int(stage.mouseX/CELL_WIDTH)) * CELL_WIDTH - _selectedItem.width;
					_selectedItem.y = (int(stage.mouseY/CELL_WIDTH)) * CELL_WIDTH - _selectedItem.height;
				}
		}
		
		private function onAddItemFromItemsPanel(event:ItemPanelEvent):void {
				var item:ObstacleItem = ObstacleItem.craeteObstacle(event.item.type);
				addObstacleItem(item);
		}
		
		private function onObstacleMouseUp(event:MouseEvent):void {
			_selectedItem = null;
		}
		private function onObstacleMouseDown(event:MouseEvent):void {
			_selectedItem = event.target as ObstacleItem;
			if (_selectedItem.filters != SELECTED_OBSTACLE_FILTERS) {
				unselectPreviousObstacle();
				_selectedItem.filters = SELECTED_OBSTACLE_FILTERS;
			}
		}
		
		private function unselectPreviousObstacle():void {
			for each(var item:ObstacleItem in _items) {
				if (item.filters == SELECTED_OBSTACLE_FILTERS) {
					item.filters = [];
				}
			}
		}
		
		private function addObstacleItem(value:ObstacleItem):void {
			if (!_items) { _items = new Vector.<ObstacleItem>(); }
			_items.push(value);
				value.addEventListener(MouseEvent.MOUSE_DOWN, onObstacleMouseDown);
				value.addEventListener(MouseEvent.MOUSE_UP, onObstacleMouseUp);
				value.x = Main.WIDTH / 2;
				value.y = Main.HEIGHT / 2;
				this.addChild(value);
		}
		private function removeObstacleItem(value:ObstacleItem):void {
			var index:int = _items.indexOf(value);
			if (index != -1) {
				_items.splice(index, 1);
				if (this.contains(value)) { this.removeChild(value); }
				value.removeEventListener(MouseEvent.MOUSE_DOWN, onObstacleMouseDown);
				value.removeEventListener(MouseEvent.MOUSE_UP, onObstacleMouseUp);
			}
		}
		
	}
}