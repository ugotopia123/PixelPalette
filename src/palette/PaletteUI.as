package palette {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class PaletteUI extends Sprite {
		[Embed(source = "../../bin/lib/palette/paletteBackground.png")]
		private static var BackgroundClass:Class;
		
		[Embed(source = "../../bin/lib/palette/paletteImport.png")]
		private static var ImportClass:Class;
		
		private static var importPalette:Sprite = new Sprite();
		private static var importFile:File = new File();
		private static var pngFilter:FileFilter = new FileFilter("PNG Images", "*.png", "PNG");
		private static var filterArray:Array = new Array();
		
		public function PaletteUI() {
			super();
			filterArray.push(pngFilter);
			importPalette.addChild(new ImportClass());
			importPalette.addEventListener(MouseEvent.CLICK, importClick);
			importFile.addEventListener(Event.SELECT, Palette.createSelectedPalette);
			addChild(new BackgroundClass());
			addChild(importPalette);
			Main.stageInstance.addChild(this);
			Main.resizeFunctions.push(updatePosition);
		}
		
		public static function addPalette(child:Palette):void {
			Main.palette.addChild(child);
			child.visible = false;
			updatePalettes();
		}
		
		public static function updatePalettes():void {
			var currentX:Number = 0;
			
			if (Palette.currentPalette == null && Palette.paletteVector.length > 0) {
				Palette.currentPalette = Palette.paletteVector[0];
			}
			
			for (var i:uint = 0; i < Palette.paletteVector.length; i++) {
				var currentPalette:Palette = Palette.paletteVector[i];
				currentPalette.selectedSprite.visible = false;
				currentPalette.visible = false;
				
				if (Palette.currentPalette == currentPalette) currentPalette.selectedSprite.visible = true;
				
				if (currentX + currentPalette.width + 16 <= 700) {
					currentPalette.visible = true;
					currentPalette.x = currentX + 16;
					currentPalette.y = 69 - currentPalette.height / 2;
					currentX = currentPalette.x + currentPalette.width;
				}
			}
			
			importPalette.x = currentX + 16;
			importPalette.y = 69 - importPalette.height / 2;
		}
		
		private static function importClick(e:MouseEvent):void {
			importFile.browseForOpen("Import Palette PNG", filterArray);
		}
		
		private function updatePosition():void {
			x = -((Main.stageInstance.stageWidth - Main.startWidth) / 2);
			y = (Main.startHeight - height) + ((Main.stageInstance.stageHeight - Main.startHeight) / 2);
			updatePalettes();
		}
	}
}