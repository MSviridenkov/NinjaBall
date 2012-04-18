package  
{
import com.greensock.TweenLite;

import fl.controls.Button;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * FeedBack
	 * @author ProBigi
	 */
	public class FeedBack extends Sprite
	{
		private var _border:FeedWindowView;
		private var _feedback:TextInput;
		private var _txt:TextField;

		private const COLORMATRIX_FILTER:ColorMatrixFilter = new ColorMatrixFilter();

		public function FeedBack()
		{
			super();
			createColorMatrixFilter();
			this.x = 100; this.y = 100;
			init();
		}
		private function init():void {
			_border = new FeedWindowView;
			_border.sendBtn.addEventListener(MouseEvent.MOUSE_OVER, onSendOver);
			_border.sendBtn.addEventListener(MouseEvent.MOUSE_OUT, onSendOut);
			_border.sendBtn.buttonMode = true;
			_border.closeBtn.addEventListener(MouseEvent.MOUSE_OVER, onCloseOver);
			_border.closeBtn.addEventListener(MouseEvent.MOUSE_OUT, onCloseOut);
			_border.closeBtn.buttonMode = true;
			this.addChild(_border);

			_border.closeBtn.gotoAndStop(1);
			_border.sendBtn.gotoAndStop(2);
			
			addFeedBack();
			addText();
		}
		
		public function get sendBtn():MovieClip { return _border.sendBtn; }
		public function get closeBtn():MovieClip { return _border.closeBtn; }
		public function get feedBack():String { return _feedback.text; }
		public function set label(value:String):void { _txt.text = value; }
		
		private function onSendOut(e:MouseEvent):void 
		{
			_border.sendBtn.gotoAndStop(2);
		}
		
		private function onSendOver(e:MouseEvent):void 
		{
			_border.sendBtn.gotoAndStop(1);
		}
		private function onCloseOut(e:MouseEvent):void 
		{
			_border.closeBtn.filters = [];
		}
		
		private function onCloseOver(e:MouseEvent):void 
		{
			_border.closeBtn.filters = [COLORMATRIX_FILTER];
		}
		private function addFeedBack():void {
			_feedback = new TextInput;
			_feedback.textField.wordWrap = true;
			_feedback.textField.multiline = true;
			_feedback.setSize(_border.width - 50, 90);
			_feedback.x = 20;
			_feedback.y = 120;
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

		private function createColorMatrixFilter():void {
			COLORMATRIX_FILTER.matrix = [1, 0, 0, 0.15, 0,
													0, 1, 0, 0.15, 0,
													0, 0, 1, 0.15, 0,
													0, 0, 0, 1, 0];
		}

}
}