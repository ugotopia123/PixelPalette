package image {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import palette.Palette;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class ImportImage extends Sprite {
		[Embed(source = "../../bin/lib/importImage.png")]
		private static var ImportClass:Class;
		private static var importFile:File = new File();
		private static var pngFilter:FileFilter = new FileFilter("PNG Images", "*.png", "PNG");
		private static var filterArray:Array = new Array();
		private static var _imageData:BitmapData;
		
		public function ImportImage() {
			filterArray.push(pngFilter);
			addChild(new ImportClass());
			Main.stageInstance.addChild(this);
			Main.resizeFunctions.push(updatePosition);
			addEventListener(MouseEvent.CLICK, onClick);
			importFile.addEventListener(Event.SELECT, importImage);
		}
		
		public static function get imageData():BitmapData { return _imageData; }
		
		private function updatePosition():void {
			x = Main.palette.x + Main.palette.width - (width * 2);
			y = Main.palette.y - (height - 20);
		}
		
		private function onClick(e:MouseEvent):void {
			if (Palette.currentPalette == null) ImageError.selectPalette.displayError();
			else importFile.browseForOpen("Import Image", filterArray);
		}
		
		private function importImage(e:Event):void {
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage);
			imageLoader.load(new URLRequest(File(e.target).nativePath));
		}
		
		private function loadImage(e:Event):void {
			_imageData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			drawImage(_imageData);
		}
		
		public static function drawImage(data:BitmapData):void {
			if (data.width * data.height > 1000000) {
				ImageError.imageTooBig.displayError();
				return;
			}
			
			var newSprite:Sprite = new Sprite();
			
			Main.drawSprite.removeChildren();
			Main.drawSprite.x = Main.drawSprite.y = 0;
			
			for (var i:uint = 0; i < data.height; i++) {
				for (var j:uint = 0; j < data.width; j++) {
					newSprite.graphics.beginFill(Palette.currentPalette.getLeastDifference(data.getPixel(j, i)));
					newSprite.graphics.drawRect(j, i, 1, 1);
					newSprite.graphics.endFill();
				}
			}
			
			var newData:BitmapData = new BitmapData(data.width, data.height);
			Main.drawSprite.addChild(new Bitmap(newData));
			newData.draw(newSprite, newSprite.transform.matrix);
			
			if (isNaN(Main.drawX)) {
				Main.drawSprite.x = Main.startWidth / 2 - Main.drawSprite.width / 2;
				Main.drawSprite.y = Main.startHeight / 2 - Main.drawSprite.height / 2;
			}
			else {
				Main.drawSprite.x = Main.drawX;
				Main.drawSprite.y = Main.drawY;
			}
		}
	}
}