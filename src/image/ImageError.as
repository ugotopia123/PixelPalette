package image {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class ImageError extends Sprite {
		[Embed(source = "../../bin/lib/error/errorBackground.png")]
		private static var BackgroundClass:Class;
		[Embed(source = "../../bin/lib/error/errorOkay.png")]
		private static var OkayClass:Class;
		[Embed(source = "../../bin/lib/error/errors/errorSelectPalette.png")]
		private static var SelectPaletteClass:Class;
		[Embed(source = "../../bin/lib/error/errors/errorLimitedPalette.png")]
		private static var LimitedPaletteClass:Class;
		[Embed(source = "../../bin/lib/error/errors/noDrawnImage.png")]
		private static var NoDrawnImageClass:Class;
		[Embed(source = "../../bin/lib/error/errors/errorRedrawPalette.png")]
		private static var RedrawPaletteClass:Class;
		[Embed(source = "../../bin/lib/error/errors/imageTooBig.png")]
		private static var ImageTooBig:Class;
		
		private static var errorVector:Vector.<ImageError> = new Vector.<ImageError>();
		private static var errorSprite:Sprite = new Sprite();
		private static var okaySprite:Sprite = new Sprite();
		private static var darkenPalette:Sprite = new Sprite();
		private static var darkenImport:Sprite = new Sprite();
		private static var _currentError:ImageError;
		private static var _selectPalette:ImageError;
		private static var _limitedPalette:ImageError;
		private static var _noDrawnImage:ImageError;
		private static var _redrawPalette:ImageError;
		private static var _imageTooBig:ImageError;
		private var _error:String;
		
		public function ImageError(error:String, backgroundClass:Class) {
			_error = error;
			visible = false;
			addChild(new backgroundClass());
			errorSprite.addChild(this);
			x = errorSprite.width / 2 - width / 2;
			y = errorSprite.height / 2 - (height / 2 + 16);
		}
		
		public function get error():String { return _error; }
		
		public function displayError():void {
			_currentError = this;
			errorSprite.visible = okaySprite.visible = darkenPalette.visible = darkenImport.visible = visible = true;
			errorSprite.x = Main.startWidth / 2 - errorSprite.width / 2;
			errorSprite.y = (Main.startHeight - Main.palette.height) / 2 - errorSprite.height / 2;
		}
		
		public static function get currentError():ImageError { return _currentError; }
		public static function get selectPalette():ImageError { return _selectPalette; }
		public static function get limitedPalette():ImageError { return _limitedPalette; }
		public static function get noDrawnImage():ImageError { return _noDrawnImage; }
		public static function get redrawPalette():ImageError { return _redrawPalette; }
		public static function get imageTooBig():ImageError { return _imageTooBig; }
		
		public static function hideError():void {
			if (_currentError != null) _currentError.visible = false;
			
			errorSprite.visible = darkenPalette.visible = darkenImport.visible = false;
			_currentError = null;
		}
		
		public static function initialize():void {
			errorSprite.visible = okaySprite.visible = darkenPalette.visible = darkenImport.visible = false;
			errorSprite.addChild(new BackgroundClass());
			errorSprite.addChild(okaySprite);
			okaySprite.addChild(new OkayClass());
			okaySprite.x = errorSprite.width / 2 - okaySprite.width / 2;
			okaySprite.y = errorSprite.height - (okaySprite.height + 8);
			okaySprite.addEventListener(MouseEvent.CLICK, okayClick);
			darkenPalette.graphics.beginFill(0x000000, 0.5);
			darkenPalette.graphics.drawRect(0, 0, Main.palette.width, Main.palette.height - 20);
			darkenPalette.graphics.endFill();
			darkenImport.graphics.beginFill(0x000000, 0.5);
			darkenImport.graphics.drawRect(0, 0, Main.importImage.width * 4, Main.importImage.height);
			_selectPalette = new ImageError("selectPalette", SelectPaletteClass);
			_limitedPalette = new ImageError("limitedPalette", LimitedPaletteClass);
			_noDrawnImage = new ImageError("noDrawnImage", NoDrawnImageClass);
			_redrawPalette = new ImageError("redrawPalette", RedrawPaletteClass);
			_imageTooBig = new ImageError("imageTooBig", ImageTooBig);
			Main.stageInstance.addChild(darkenPalette);
			Main.stageInstance.addChild(darkenImport);
			Main.stageInstance.addChild(errorSprite);
			Main.resizeFunctions.push(updatePosition);
			updatePosition();
		}
		
		public static function getError(error:String):ImageError {
			for (var i:uint = 0; i < errorVector.length; i++) {
				if (errorVector[i]._error == error) return errorVector[i];
			}
			
			return null;
		}
		
		private static function okayClick(e:MouseEvent):void {
			hideError();
		}
		
		private static function updatePosition():void {
			darkenPalette.x = Main.palette.x;
			darkenPalette.y = Main.palette.y + 20;
			darkenImport.x = Main.resetImage.x;
			darkenImport.y = Main.resetImage.y;
		}
	}
}