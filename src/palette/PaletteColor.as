package palette {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class PaletteColor extends Sprite {
		private var _color:uint;
		private var _red:uint;
		private var _green:uint;
		private var _blue:uint;
		
		public function PaletteColor(parent:Palette, color:uint) {
			parent.paletteColors.push(this);
			_color = color;
			_red = (color >> 16) & 0xFF;
			_green = (color >> 8) & 0xFF;
			_blue = color & 0xFF;
			
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 6, 6);
			graphics.endFill();
			parent.addChild(this);
		}
		
		public function get color():uint { return _color; }
		public function get red():uint { return _red; }
		public function get green():uint { return _green; }
		public function get blue():uint { return _blue; }
		
		public function difference(color:uint):uint {
			var redDiff:uint = Math.abs(_red - ((color >> 16) & 0xFF));
			var greenDiff:uint = Math.abs(_green - ((color >> 8) & 0xFF));
			var blueDiff:uint = Math.abs(_blue - (color & 0xFF));
			return redDiff + greenDiff + blueDiff;
		}
	}
}