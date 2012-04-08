package  
{
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

import rpc.GameRpc;

/**
	 * FeedBack
	 * @author ProBigi
	 */
	public class FeedBack extends Sprite
	{
		private var _width:int;
		private var _height:int
		private var _border:Sprite;
		private var _feedback:TextInput;
		private var _txt:TextField;
		private var _feedBtn:Button;
		public function FeedBack(width:int = 400, height:int = 200) 
		{
			super();
			this.x = 100; this.y = 100;
			_width = width;
			_height = height;
			init();
		}

		public function get btn():Button { return _feedBtn; }

		private function init():void {
			_border = new Sprite;
			_border.graphics.lineStyle(2,0xC0C0C0);
			_border.graphics.beginFill(0xFFFFFF)
			_border.graphics.drawRoundRect(0, 0, _width, _height, 10, 10);
			_border.graphics.endFill();
			this.addChild(_border);
			
			addFeedBack();
			addText();
			addButton();
			_feedBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		private function addFeedBack():void {
			_feedback = new TextInput;
			_feedback.textField.wordWrap = true;
			_feedback.setSize(_width - 50, 60);
			_feedback.textField.autoSize = TextFieldAutoSize.LEFT;
			_feedback.x = _border.x + 10;
			_feedback.y = _border.height - 70;
			this.addChild(_feedback);
		}
		private function addText():void {
			_txt = new TextField;
			_txt.selectable = false;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat("Century Gothic", 12);
			_txt.defaultTextFormat = format;
			_txt.text = "Can You please say something about the game:";
			_txt.x = _feedback.x;
			_txt.y = _feedback.y - 20;
			this.addChild(_txt);
		}
		private function addButton():void {
			_feedBtn = new Button;
			_feedBtn.textField.autoSize = TextFieldAutoSize.LEFT;
			_feedBtn.setSize(20, _feedback.height);
			_feedBtn.label = "";
			_feedBtn.x = _feedback.width + 20;
			_feedBtn.y = _feedback.y;
			this.addChild(_feedBtn);
		}

		private function onBtnClick(event:MouseEvent):void {
			_feedBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
			if (_feedback.text != "") {
				GameRpc.instance.send({ninja_request : "save_feedback", feedback : _feedback.text});
			}
		}
	}
}