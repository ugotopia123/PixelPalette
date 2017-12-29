package{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import image.ExportImage;
	import image.ImageError;
	import image.ImportImage;
	import image.RedrawImage;
	import image.ResetImage;
	import palette.PaletteUI;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Main extends Sprite {
		public static var resizeFunctions:Vector.<Function> = new Vector.<Function>();
		public static var stageInstance:Stage;
		private static var dragging:Boolean = false;
		private static var prevMouseX:Number;
		private static var postMouseX:Number;
		private static var prevMouseY:Number = NaN;
		private static var postMouseY:Number = NaN;
		private static var _drawX:Number = NaN;
		private static var _drawY:Number = NaN;
		private static var _scale:uint = 1;
		private static var _startWidth:Number;
		private static var _startHeight:Number;
		private static var mouseTimer:Timer = new Timer(1000 / 60);
		private static var _drawSprite:Sprite = new Sprite();
		private static var _palette:PaletteUI;
		private static var _redrawImage:RedrawImage;
		private static var _importImage:ImportImage;
		private static var _exportImage:ExportImage;
		private static var _resetImage:ResetImage;
		
		public function Main() {
			if (stage) initialize();
			else addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resize);
			stageInstance = stage;
			_startWidth = stage.stageWidth;
			_startHeight = stage.stageHeight;
			addChild(_drawSprite);
			_palette = new PaletteUI();
			_redrawImage = new RedrawImage();
			_importImage = new ImportImage();
			_exportImage = new ExportImage();
			_resetImage = new ResetImage();
			ImageError.initialize();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startDrawDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDrawDrag);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, zoomHandler);
			mouseTimer.addEventListener(TimerEvent.TIMER, updateTimer);
			mouseTimer.start();
		}
		
		public static function get startWidth():Number { return _startWidth; }
		public static function get startHeight():Number { return _startHeight; }
		public static function get drawX():Number { return _drawX; }
		public static function get drawY():Number { return _drawY; }
		public static function get scale():uint { return _scale; }
		public static function get drawSprite():Sprite { return _drawSprite; }
		public static function get palette():PaletteUI { return _palette; }
		public static function get redrawImage():RedrawImage { return _redrawImage; }
		public static function get importImage():ImportImage { return _importImage; }
		public static function get exportImage():ExportImage { return _exportImage; }
		public static function get resetImage():ResetImage { return _resetImage; }
		
		public static function resetScale():void {
			_scale = 1;
			_drawSprite.scaleX = _drawSprite.scaleY = 1;
		}
		
		private static function resize(e:Event):void {
			for (var i:uint = 0; i < resizeFunctions.length; i++) {
				resizeFunctions[i].call();
			}
		}
		
		private static function startDrawDrag(e:MouseEvent):void {
			dragging = true;
		}
		
		private static function stopDrawDrag(e:MouseEvent):void {
			dragging = false;
		}
		
		private static function zoomHandler(e:MouseEvent):void {
			if (ImportImage.imageData == null) return;
			
			var scroll:Number = e.delta;
			
			if (scroll > 0) scroll = 1;
			else scroll = -1;
			
			if (_scale + scroll < 1) _scale = 1;
			else _scale += scroll;
			
			if (_scale > 10) _scale = 10;
			else if (_scale < 1) _scale = 1;
			
			_drawSprite.scaleX = _drawSprite.scaleY = _scale;
		}
		
		private static function updateTimer(e:TimerEvent):void {
			prevMouseX = stageInstance.mouseX;
			prevMouseY = stageInstance.mouseY;
			
			if (isNaN(postMouseX)) postMouseX = prevMouseX;
			if (isNaN(postMouseY)) postMouseY = prevMouseY;
			
			if (dragging && ImportImage.imageData != null) {
				_drawSprite.x -= (postMouseX - prevMouseX);
				_drawSprite.y -= (postMouseY - prevMouseY);
				_drawX = _drawSprite.x;
				_drawY = _drawSprite.y;
			}
			
			postMouseX = stageInstance.mouseX;
			postMouseY = stageInstance.mouseY;
		}
	}
}