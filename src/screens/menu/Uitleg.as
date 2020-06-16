package screens.menu
{

	import flash.geom.Rectangle;
	
	import components.PageIndicatorBullet;
	import components.ScrollableSprite;
	
	import events.ScrollEvent;
	
	import interfaces.GameScreen;
	
	import screens.uitleg.DoelUitleg;
	import screens.uitleg.EzelUitleg;
	import screens.uitleg.KoehandelUitleg1;
	import screens.uitleg.KoehandelUitleg2;
	import screens.uitleg.KoehandelUitleg3;
	import screens.uitleg.KooprechtUitleg;
	import screens.uitleg.PuntenUitleg;
	import screens.uitleg.StartUitleg;
	import screens.uitleg.UitlegScreen;
	import screens.uitleg.VeilenUitleg;
	
	import starling.display.Sprite;
	
	public class Uitleg extends GameScreen
	{

		private var pageIndicatorBullets:Array;

		private var currentSlide:int;

		private var uitlegScreens:Array;
		public function Uitleg()
		{
			super();
			
			var game:Game = Game.getGame();
			screenTitle = "Uitleg"
				
			var screenHolder:ScrollableSprite = new ScrollableSprite();
			screenHolder.addEventListener(ScrollEvent.ScrollSettled, scrollStopped);
			addChild(screenHolder);
			currentSlide = 0;
			
			uitlegScreens = [];
			
			// init screens
			
			var doelUitleg:DoelUitleg = new DoelUitleg('Doel van het spel');
			uitlegScreens.push(doelUitleg);
			
			var startUitleg:StartUitleg = new StartUitleg('Start van het spel');
			uitlegScreens.push(startUitleg);
			
			var veilenUitleg:VeilenUitleg = new VeilenUitleg('Veilen');
			uitlegScreens.push(veilenUitleg);
			
			var kooprechtUitleg:KooprechtUitleg = new KooprechtUitleg('Kooprecht');
			uitlegScreens.push(kooprechtUitleg);
			
			var koehandelUitleg1:KoehandelUitleg1 = new KoehandelUitleg1('Koehandel');
			uitlegScreens.push(koehandelUitleg1);
			
			var koehandelUitleg2:KoehandelUitleg2 = new KoehandelUitleg2('Koehandel');
			uitlegScreens.push(koehandelUitleg2);
			
			var koehandelUitleg3:KoehandelUitleg3 = new KoehandelUitleg3('Koehandel');
			uitlegScreens.push(koehandelUitleg3);
			
			var puntenUitleg:PuntenUitleg = new PuntenUitleg('Punten');
			uitlegScreens.push(puntenUitleg);
			
			var ezelUitleg:EzelUitleg = new EzelUitleg('De ezel');
			uitlegScreens.push(ezelUitleg);
			
			screenHolder.maxSlideIndex = uitlegScreens.length-1;
			
			for(var i:int in uitlegScreens){
				var currentScreen:UitlegScreen = uitlegScreens[i];
				currentScreen.x = i * game.stageWidth;
				screenHolder.addChild(currentScreen);
				if(i == 0){
					currentScreen.animateIn();
				}
			}
			
			this.clipRect = new Rectangle(0, 0, game.stageWidth,game.stageHeight);
			
			var pageIndicatorSize:Number = 8;
			var pageIndicator:Sprite = new Sprite();
			var pageIndicatorWidth:Number = pageIndicatorSize * uitlegScreens.length * 1.5;
			pageIndicator.x = (game.stageWidth - pageIndicatorWidth) /2;
			pageIndicator.y = game.stageHeight * 0.78;
			
			addChild(pageIndicator);
			//draw page indicator
			
			pageIndicatorBullets = [];
			
			for(var z:int in uitlegScreens){
				var pageIndicatorBullet:PageIndicatorBullet = new PageIndicatorBullet(pageIndicatorSize);
				pageIndicatorBullet.x = z * pageIndicatorSize * 1.5;
				pageIndicatorBullets.push(pageIndicatorBullet);
				pageIndicator.addChild(pageIndicatorBullet);
				
				//make first pageIndicatorBullet active
				
				if(z == 0){
					pageIndicatorBullet.makeActive();
				}
			}
			
		}
		
		private function scrollStopped(event:ScrollEvent):void
		{

			var newIndex:int = event.values['index'];
			if(currentSlide != newIndex){
				//do stuff on new index slide index
				currentSlide = newIndex;
				
				//make other slide indicators inactive
				for(var z:int in pageIndicatorBullets){
					var pageIndicatorBullet:PageIndicatorBullet = pageIndicatorBullets[z];
					pageIndicatorBullet.makeInactive();
					if(z == currentSlide){
						pageIndicatorBullet.makeActive();
					}
				}
				
				// reset other pages
				for(var y:int in uitlegScreens){
					var uitlegScreen:UitlegScreen = uitlegScreens[y];
					uitlegScreen.resetAnimateIn();
				}
				
				// init animations on current page
				uitlegScreen = uitlegScreens[currentSlide];
				uitlegScreen.animateIn();
				
			}
		}
	}
}