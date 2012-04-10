package  
{
	import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

import rpc.GameRpc;

/**
	 * FeedBack
	 * @author ProBigi
	 */
	public class FeedBack extends Sprite
	{
		private var _border:FeedBackView;
		private var _feedback:TextInput;
		private var _txt:TextField;
		public function FeedBack() 
		{
			super();
			this.x = 100; this.y = 100;
			init();
		}
		private function init():void {
			_border = new FeedBackView;
			postBtn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			postBtn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			postBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			_border.postBtn.buttonMode = true;
			this.addChild(_border);
			
			addFeedBack();
			addText();
		}

		public function get postBtn():MovieClip { return _border.postBtn; }
		public function get feedBack():String { return _feedback.text; }
		public function set label(value:String):void { _txt.text = value; }
		
		private function onOut(e:MouseEvent):void 
		{
			_border.postBtn.gotoAndStop(1);
		}
		
		private function onOver(e:MouseEvent):void 
		{
			_border.postBtn.gotoAndStop(2);
		}
		private function addFeedBack():void {
			_feedback = new TextInput;
			_feedback.textField.wordWrap = true;
			_feedback.textField.multiline = true;
			_feedback.setSize(_border.width - 20, 80);
			_feedback.x = 9;
			_feedback.y = 140;
			_border.addChild(_feedback);
		}
		private function addText():void {
			_txt = new TextField;
			_txt.selectable = false;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat("Tw Cen MT", 13); //Bauhaus 93, Century Gothic
			_txt.defaultTextFormat = format;
			_txt.text = "Can You please say something about our game:";
			_txt.x = _feedback.x;
			_txt.y = _feedback.y - 20;
			_border.addChild(_txt);
		}


		private function onBtnClick(event:MouseEvent):void {
			postBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
			if (_feedback.text != "") {
				 GameRpc.instance.send({ninja_request : "save_feedback", feedback : _feedback.text});
			}
		}

	}
}