/**
 * Created by : Dmitry
 * Date: 4/4/12
 * Time: 6:58 AM
 */
package view.panel {
import fl.controls.Button;

import flash.display.Sprite;
import flash.text.TextFieldAutoSize;

public class ItemsPanelCustomization {
	private var _itemsPanel:ItemsPanel;

	private var _frame:Sprite;
	private var _border:Sprite;
	private var _cancelBtn:Button;

	public function ItemsPanelCustomization(itemsPanel:ItemsPanel) {
		super();
		_itemsPanel = itemsPanel;
		_cancelBtn = itemsPanel.cancelBtn;
	}

	public function customize():void {
		createFrame();
		createButtons();
	}

		//
		private function createFrame():void {
			//_frame = new Sprite();
			//_frame.graphics.beginFill(0xA0A0A0, .7);
			//_frame.graphics.drawRect(0, 0, Main.WIDTH, Main.HEIGHT);
			//_frame.graphics.endFill();
			//_itemsPanel.addChild(_frame);

			_border = new Sprite;
			_border.graphics.lineStyle(1);
			_border.graphics.beginFill(0xFFFFFF);
			_border.graphics.drawRect(0, 0, 400, 250);
			_border.graphics.endFill();
			_itemsPanel.addChild(_border);
		}
		private function createButtons():void {
			_cancelBtn.label = "Cancel";
			_cancelBtn.textField.autoSize = TextFieldAutoSize.LEFT;
			_cancelBtn.x = _border.width/2 - _cancelBtn.width/2;
			_cancelBtn.y = _border.height - 30;
			_border.addChild(_cancelBtn);
		}
}
}
