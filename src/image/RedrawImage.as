package image {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import palette.Palette;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class RedrawImage extends Sprite {
		[Embed(source = "../../bin/lib/redrawImage.png")]
		private static var BackgroundClass:Class;
		
		public function RedrawImage() {
			addChild(new BackgroundClass());
			Main.stageInstance.addChild(this);
			Main.resizeFunctions.push(updatePosition);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function updatePosition():void {
			x = Main.palette.x + Main.palette.width - (width * 3);
			y = Main.palette.y - (height - 20);
		}
		
		private function onClick(e:MouseEvent):void {
			if (ImportImage.imageData == null) ImageError.noDrawnImage.displayError();
			else if (Palette.currentPalette == null) ImageError.redrawPalette.displayError();
			else ImportImage.drawImage(ImportImage.imageData);
		}
	}
}