package components
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class DefaultButton extends starling.display.Sprite
	{

		private var darkFilter:ColorMatrixFilter;

		private var button:Image;

		private var toggleAble:Boolean;

		private var active:Boolean;

		private var textField:TextField;

		private var game:Game;
		public function DefaultButton(desiredWidth:Number, desiredHeight:Number, text:String, fontSize:Number, backgroundColor:int = 0, toggle:Boolean = false, textOffset:Number = 0)
		{
			super();
			
			toggleAble = toggle;
			active = false;
			game = Game.getGame();
			
			var backgroundSprite:flash.display.Sprite = new flash.display.Sprite();
			backgroundSprite.graphics.beginFill(0x000000,0.8);
			backgroundSprite.graphics.drawRect(Config.borderThickness,Config.borderThickness,desiredWidth*1, 1*desiredHeight);
			backgroundSprite.graphics.beginFill(Config.yellowColor);
			//backgroundSprite.graphics.beginFill(Config.redColor);
			backgroundSprite.graphics.drawRect(0,0,desiredWidth*1, 1*desiredHeight);
			if(backgroundColor == 0){
				backgroundSprite.graphics.beginFill(Config.redColor);
			}else{
				backgroundSprite.graphics.beginFill(backgroundColor);
			}
			
			backgroundSprite.graphics.drawRect(Config.borderThickness,Config.borderThickness,desiredWidth*1-Config.borderThickness*2,desiredHeight*1-Config.borderThickness*2);
			
			textField = new TextField(desiredWidth,desiredHeight*0.9,text.toUpperCase());
			textField.color = 0xffffff;
			textField.y = (desiredHeight*0.1) + textOffset;
			textField.fontSize = fontSize * Config.fontScaling;
			textField.fontName = Config.fontName;
			var bitmapData:BitmapData = new BitmapData(desiredWidth*1 + Config.borderThickness, desiredHeight*1 + Config.borderThickness, true,0);
			bitmapData.draw(backgroundSprite);
			var texture:Texture = Texture.fromBitmapData(bitmapData,false,false,1);
			
			button = new Image(texture);
			darkFilter = new ColorMatrixFilter();
			darkFilter.adjustBrightness(-0.2);
		
			addChild(button);
			addChild(textField);
			
			pivotX = desiredWidth /2;
			pivotY = desiredHeight /2; 
			
			addEventListener(TouchEvent.TOUCH,buttonClicked);
			
		}
		
		private function buttonClicked(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				game.assets.buttonSound.play(0,0);
				if(!toggleAble){
					button.filter = darkFilter;
					y  += 2;
				}else{
					if(!active){
						
						button.filter = darkFilter;
						y  += 2;
					}
				}				
			}
			if(touch.phase == TouchPhase.ENDED){
				if(!toggleAble){
					button.filter = null;
					y  -= 2;
				}else{
					if(!active){
						active = !active;
					}else{
						active = !active;
						button.filter = null;
						y  -= 2;
					}
				}
			}
		}
		public function set text(text:String):void{
			textField.text = text;
		}
		
		public function makeActive():void{
			if(!active && toggleAble){
				active = !active;
				button.filter = darkFilter;
				y  += 2;
			}
		}
		public function makeInactive():void{
			if(active && toggleAble){
				active = !active;
				button.filter = null;
				y  -= 2;
			}
		}
	}
}