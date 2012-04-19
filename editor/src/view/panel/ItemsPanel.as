package view.panel
{
	import com.greensock.TweenLite;
import com.greensock.TweenMax;

import fl.controls.Button;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import mx.effects.Glow;

import view.obstacle.MillObstacle;

import view.obstacle.ObstacleItem;
	import view.obstacle.SquareObstacle;
	import events.ItemPanelEvent;
	/**
	 * Панель элементов редактора
	 * @author ProBigi
	 */
	public class ItemsPanel extends Sprite implements IObjectController
	{
		private var _cancelBtn:Button;
		
		private var _items:Vector.<ObstacleItem>;

		private var _customization:ItemsPanelCustomization;

		private var GLOW_FILTER:GlowFilter = new GlowFilter(0xfaa43c, 1, 6, 6, 10, 1, true);
		
		public function ItemsPanel() {
			init();
			createItems();
		}
		
		public function get cancelBtn():Button { return _cancelBtn; }
		
		public function init():void {
			_cancelBtn = new Button();
			_customization = new ItemsPanelCustomization(this);
			_customization.customize();

			addListeners();
		}
		public function clear():void {
			removeListeners();
		}
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		private function removeListeners():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function createItems():void {
			_items = new Vector.<ObstacleItem>();
			_items.push(new SquareObstacle());
			_items.push(new MillObstacle());
			addItemsToView();
			addItemsListeners();
		}
		private function addItemsToView():void {
			for (var i:int = 0; i < _items.length; ++i) {
				_items[i].x = 30 + i * (_items[i].width + 10);
				_items[i].y = 50;
				_items[i].alpha = .8;
				this.addChild(_items[i]);
			}
		}
		private function addItemsListeners():void {
			for each (var item:ObstacleItem in _items) {
				item.addEventListener(MouseEvent.MOUSE_OVER,  onItemMouseOver);
				item.addEventListener(MouseEvent.MOUSE_OUT,  onItemMouseOut);
				item.addEventListener(MouseEvent.CLICK,  onItemClick);
			}
		}
		
		private function onItemMouseOver(event:MouseEvent):void {
			TweenMax.to(event.target, .3, {glowFilter:{color: 0xfaa43c, alpha : 1, blurX: 20, blurY: 20, inner: true}});
		}
		private function onItemMouseOut(event:MouseEvent):void {
			TweenMax.to(event.target, .3, {glowFilter:{alpha : 0, blurX: 20, blurY: 20, inner: true}});
		}
		private function onItemClick(event:MouseEvent):void {
			dispatchEvent(new ItemPanelEvent(ItemPanelEvent.ADD_ITEM, event.target as ObstacleItem));
		}
		
		private function onMouseDown(event:MouseEvent):void {
				startDrag();
		}
		private function onMouseUp(event:MouseEvent):void {
				stopDrag();
		}

	}
}