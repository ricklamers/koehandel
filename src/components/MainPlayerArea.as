package components
{
	import com.greensock.TweenLite;
	
	import flash.utils.setTimeout;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class MainPlayerArea extends Sprite
	{

		private var highLight:Image;

		public var animalArea:Sprite;

		public var moneyArea:Sprite;
		private var movedMoneyDown:int;
		private var movedAnimalsDown:int;
		
		public var moneyShowing:Boolean = false;
		public var animalsShowing:Boolean = false;
		
		public var mainPlayerBidArea:Sprite;
		public var mainPlayerChoiceArea:Sprite;
		public  var mainPlayerSellChoiceArea:Sprite;
		private var game:Game;
		public function MainPlayerArea()
		{
			super();
			game = Game.getGame();
			var areaBackground:Image = new Image(Texture.fromColor(game.stageWidth,game.stageHeight * 0.3, 0x77000000,false,1));
			addChild(areaBackground);
			areaBackground.visible = false;
			
			//init bid area
			mainPlayerBidArea = new Sprite();
			mainPlayerBidArea.visible = false;
			
			//init choice area
			mainPlayerChoiceArea = new Sprite();
			mainPlayerChoiceArea.visible = false;
			
			//init sellChoiceArea
			mainPlayerSellChoiceArea = new Sprite();
			mainPlayerSellChoiceArea.visible = false;
			
			addChild(mainPlayerChoiceArea);
			addChild(mainPlayerSellChoiceArea);
			addChild(mainPlayerBidArea);
			
			moneyArea = new Sprite()
			moneyArea.addEventListener(TouchEvent.TOUCH, touchMoney);
			addChild(moneyArea);
			
			animalArea = new Sprite();
			animalArea.addEventListener(TouchEvent.TOUCH, touchAnimals);
			addChild(animalArea);
			
			
			highLight = new Image(game.assets.textureAtlas1.getTexture("filter_blur"));
			highLight.blendMode = BlendMode.ADD;

			highLight.alpha = 0;
			setTimeout(function():void{
				addChildAt(highLight,0);
				highLight.y = highLight.height * 0.2;
			},1);
			highLight.width = areaBackground.width * 1;
			highLight.x = (areaBackground.width - highLight.width) /2;
		}
		public function makeActive():void{
			TweenLite.to(highLight,0.5,{alpha:0.3});
		}
		private function touchMoney(event:TouchEvent):void{
			
			var touch:Touch = event.touches[0];
			
			
			if(!game.singlePlayerGameScreen.tradeProcess_active){
				if(touch.phase == TouchPhase.MOVED){
					
					var dir:int = touch.globalY - touch.previousGlobalY;
	
					if(dir > 0){
						movedMoneyDown += dir;
					}
					
					// after moving 30 pixels down hide money
					if(movedMoneyDown > 30){
						// hide money
						hideMoney();
						movedMoneyDown = 0;
					}
				}
				if(touch.phase == TouchPhase.ENDED){
					movedMoneyDown = 0;
				}
			}
		}
		
		private function touchAnimals(event:TouchEvent):void{
			var touch:Touch = event.touches[0];

				if(touch.phase == TouchPhase.MOVED){
					
					var dir:int = touch.globalY - touch.previousGlobalY;
					
					if(dir > 0){
						movedAnimalsDown += dir;
					}
					
					// after moving 30 pixels down hide money
					if(movedAnimalsDown > 30){
						// hide money
						hideAnimals();
						movedAnimalsDown = 0;
					}
				}
				if(touch.phase == TouchPhase.ENDED){
					movedAnimalsDown = 0;
				}
		}
		public function hideMoney():void{
			moneyShowing = false;
			TweenLite.to(this.moneyArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
		}
		public function hideAnimals():void{
			animalsShowing = false;
			TweenLite.to(this.animalArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
		}
		public function makeInactive():void{
			TweenLite.to(highLight,0.5,{alpha:0});
		}
	}
}