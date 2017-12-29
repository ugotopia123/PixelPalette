package image {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class ResetImage extends Sprite {
		[Embed(source = "../../bin/lib/resetImage.png")]
		private static var BackgroundClass:Class;
		
		public function ResetImage() {
			addChild(new BackgroundClass());
			Main.stageInstance.addChild(this);
			Main.resizeFunctions.push(updatePosition);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function updatePosition():void {
			x = Main.palette.x + Main.palette.width - (width * 4);
			y = Main.palette.y - (height - 20);
		}
		
		private function onClick(e:MouseEvent):void {
			Main.resetScale();
			Main.drawSprite.x = Main.startWidth / 2 - Main.drawSprite.width / 2;
			Main.drawSprite.y = Main.startHeight / 2 - Main.drawSprite.height / 2;
		}
	}
}