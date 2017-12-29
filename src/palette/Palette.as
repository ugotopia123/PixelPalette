package palette {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import image.ImageError;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Palette extends Sprite {
		[Embed(source = "../../bin/lib/palette/paletteDelete.png")]
		private static var DeleteClass:Class;
		[Embed(source = "../../bin/lib/palette/paletteSelected.png")]
		private static var SelectedClass:Class;
		
		private static const _maxColors:uint = 100;
		private static var _paletteVector:Vector.<Palette> = new Vector.<Palette>();
		private static var _currentPalette:Palette;
		private var _paletteColors:Vector.<PaletteColor> = new Vector.<PaletteColor>();
		private var paletteSprite:Sprite = new Sprite();
		private var deleteButton:Sprite = new Sprite();
		private var _selectedSprite:Sprite = new Sprite();
		private var paletteData:BitmapData;
		
		public function Palette() {
			super();
			deleteButton.addChild(new DeleteClass());
			_selectedSprite.addChild(new SelectedClass());
			_selectedSprite.visible = false;
			_paletteVector.push(this);
			deleteButton.addEventListener(MouseEvent.CLICK, deleteClick);
			paletteSprite.addEventListener(MouseEvent.CLICK, onClick);
			addChild(paletteSprite);
			addChild(deleteButton);
			addChild(_selectedSprite);
			updatePalette();
			PaletteUI.addPalette(this);
		}
		
		public function get selectedSprite():Sprite { return _selectedSprite; }
		public function get paletteColors():Vector.<PaletteColor> { return _paletteColors; }
		
		public function getLeastDifference(color:uint):uint {
			var currentLowest:uint;
			var lowest:uint;
			
			for (var i:uint = 0; i < _paletteColors.length; i++) {
				var difference:uint = _paletteColors[i].difference(color);
				
				if (i == 0 || currentLowest > difference) {
					currentLowest = difference;
					lowest = i;
				}
			}
			
			return _paletteColors[lowest].color;
		}
		
		public function hasColor(color:uint):Boolean {
			for (var i:uint = 0; i < _paletteColors.length; i++) {
				if (_paletteColors[i].color == color) return true;
			}
			
			return false;
		}
		
		private function updatePalette():void {
			var currentX:uint = 0;
			var currentY:uint = 0;
			
			for (var i:uint = 0; i < _paletteColors.length; i++) {
				currentX = i % 10;
				paletteSprite.addChild(_paletteColors[i]);
				_paletteColors[i].x = currentX * _paletteColors[i].width;
				_paletteColors[i].y = currentY * _paletteColors[i].height;
				
				if (currentX == 9) currentY++;
			}
			
			deleteButton.x = width - deleteButton.width;
			deleteButton.y = paletteSprite.height + 4;
			_selectedSprite.x = 0;
			_selectedSprite.y = paletteSprite.height + 4;
			PaletteUI.updatePalettes();
		}
		
		private function onClick(e:MouseEvent):void {
			_currentPalette = this;
			PaletteUI.updatePalettes();
		}
		
		private function deleteClick(e:MouseEvent):void {
			if (_currentPalette == this) _currentPalette = null;
			
			visible = false;
			_paletteVector.removeAt(_paletteVector.indexOf(this));
			PaletteUI.updatePalettes();
		}
		
		public static function get maxColors():uint { return _maxColors; }
		public static function get paletteVector():Vector.<Palette> { return _paletteVector; }
		public static function get currentPalette():Palette { return _currentPalette; }
		public static function set currentPalette(value:Palette):void { _currentPalette = value; }
		
		public static function createSelectedPalette(e:Event):void {
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadPalette);
			imageLoader.load(new URLRequest(File(e.target).nativePath));
		}
		
		public static function createPathedPalette(path:String):void {
		}
		
		private static function loadPalette(e:Event):void {
			var newPalette:Palette = new Palette();
			var currentCount:uint = 0;
			newPalette.paletteData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			
			paletteHeight: for (var i:uint = 0; i < newPalette.paletteData.height; i++) {
				for (var j:uint = 0; j < newPalette.paletteData.width; j++) {
					var pixelColor:uint = newPalette.paletteData.getPixel(j, i);
					
					if (newPalette.hasColor(pixelColor)) continue;
					
					new PaletteColor(newPalette, pixelColor);
					currentCount++;
					
					if (currentCount == _maxColors) {
						ImageError.limitedPalette.displayError();
						break paletteHeight;
					}
				}
			}
			
			newPalette.updatePalette();
			e.target.removeEventListener(Event.COMPLETE, loadPalette);
		}
	}
}