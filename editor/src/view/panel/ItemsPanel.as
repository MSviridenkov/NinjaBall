package view.panel
{
	import fl.controls.Button;
	import flash.display.Sprite;
	/**
	 * Панель элементов редактора
	 * @author ProBigi
	 */
	public class ItemsPanel extends Sprite implements IObjectController
	{
		private var _cancelBtn:Button;
		private var _selectBtn:Button;

		private var _customization:ItemsPanelCustomization;
		
		public function ItemsPanel() {
			init();
			createItems();
		}
		
		public function get cancelBtn():Button { return _cancelBtn; }
		public function get selectBtn():Button { return _selectBtn; }
		
		public function init():void {
			_selectBtn = new Button();
			_cancelBtn = new Button();
			_customization = new ItemsPanelCustomization(this);
			_customization.customize();

			addListeners();
		}
		public function clear():void {
			removeListeners();
		}
		private function addListeners():void {
			
		}
		private function removeListeners():void {
			
		}

		private function createItems():void {

		}

	}
}