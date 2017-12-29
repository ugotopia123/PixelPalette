package image {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class ExportImage extends Sprite {
		[Embed(source = "../../bin/lib/exportImage.png")]
		private static var ExportClass:Class;
		private static var saveReference:FileReference = new FileReference();
		
		public function ExportImage() {
			addChild(new ExportClass());
			Main.stageInstance.addChild(this);
			Main.resizeFunctions.push(updatePosition);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function updatePosition():void {
			x = Main.palette.x + Main.palette.width - width;
			y = Main.palette.y - (height - 20);
		}
		
		private function onClick(e:MouseEvent):void {
			if (ImportImage.imageData == null) ImageError.noDrawnImage.displayError();
			else {
				var bitmapData:BitmapData = new BitmapData(Main.drawSprite.width / Main.scale, Main.drawSprite.height / Main.scale);
				bitmapData.draw(Main.drawSprite);
				var byteArray:ByteArray = PNGEncoder.encode(bitmapData);
				saveReference.save(byteArray, "image.png");
			}
		}
	}
}