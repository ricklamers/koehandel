package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(width="1136", height="640", frameRate="60", backgroundColor="#ffffff")]
	public class Koehandel extends Sprite 
	{
	
		private var _starling:Starling;

		private var loadingMessage:TextField;
 
		private var tf:TextFormat; 

		public function Koehandel()
		{ 
			super();
			
			// Start the MonsterDebugger

			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loadingMessage = new TextField();
			tf = new TextFormat("Arial",32,0x000000,true,null);
			tf.align = TextFormatAlign.CENTER;
			loadingMessage.defaultTextFormat = tf;
//			loadingMessage.text = stage.fullScreenWidth + " x "+stage.fullScreenHeight;
			loadingMessage.text = "Laden...";

			setTimeout(function():void{
				init();
				
			},1);			
			
		}
		
		private function init():void{
			
			loadingMessage.width = stage.stageWidth;
			loadingMessage.y = (stage.stageHeight-loadingMessage.height/2) / 2;
			addChild(loadingMessage);
			
			
			// detect desktop
			//if(Capabilities.touchscreenType == TouchscreenType.NONE){
				//_starling = new Starling(Game, stage,new Rectangle(0,0,1136, 640));
			//}else{
				//_starling = new Starling(Game, stage,new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight));
			//}
			
			
			_starling = new Starling(Game, stage,new Rectangle(0,0, stage.fullScreenWidth, stage.fullScreenHeight));
			
			
			//_starling.showStats = true;
			stage.frameRate = 60;
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, appDeactivated);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, appActivated);

			
			var isPad:Boolean = (stage.fullScreenWidth == 768 || stage.fullScreenWidth == 1536);
			
			//if(stage.fullScreenHeight >= 640){
				//_starling.stage.stageHeight  = stage.fullScreenHeight * 2;
				//_starling.stage.stageWidth = stage.fullScreenWidth * 2;
			//}
			//if(stage.fullScreenHeight >= 480 && stage.fullScreenHeight < 640){
				//_starling.stage.stageHeight  = stage.fullScreenHeight / 1.5;
				//_starling.stage.stageWidth = stage.fullScreenWidth / 1.5;
			//}
			//if(stage.fullScreenHeight < 480){
				//_starling.stage.stageHeight  = stage.fullScreenHeight;
				//_starling.stage.stageWidth = stage.fullScreenWidth;
			//}
			//if(stage.fullScreenHeight > 900){
				//_starling.stage.stageHeight  = stage.fullScreenHeight / 3;
				//_starling.stage.stageWidth = stage.fullScreenWidth / 3;
			//}
			
			_starling.stage.stageHeight  = stage.fullScreenHeight / 1.5;
			_starling.stage.stageWidth = stage.fullScreenWidth / 1.5;
			
			
			// detect desktop
			//if(Capabilities.touchscreenType == TouchscreenType.NONE){
				//_starling.stage.stageWidth = 1136;
				//_starling.stage.stageHeight = 640;
			//}
			
			_starling.antiAliasing = 0;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED,rootCreated);
			
			
			function rootCreated(e:starling.events.Event):void{
	
				(Starling.current.root as Game).init();
				loadingMessage.visible = false;
				
			}
			_starling.start();
			
			loadingMessage.text = "Laden - started Starling";
			
		}
		
		protected function appActivated(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
			SoundMixer.soundTransform = new SoundTransform(1);
		}
		
		protected function appDeactivated(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
			SoundMixer.soundTransform = new SoundTransform(0);
		}
		
	}
}