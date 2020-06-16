package screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.utils.setTimeout;
	
	import components.DefaultButton;
	import components.DefaultInputfield;
	
	import interfaces.GameScreen;
	
	import managers.Assets;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class Startscreen extends GameScreen
	{

		private var game:Game;
		private var textField:TextField;
		private var backgroundTexture:Texture;
		private var backgroundImage:Image;
		public var backgroundScrollSpeed:Number = 20000;

		private var logo:Image;

		private var play_button:DefaultButton;

		private var explain_button:DefaultButton;

		private var register_email_button:DefaultButton;

		private var register_facebook_button:DefaultButton;

		private var show_login_email_button:DefaultButton;

		private var login_facebook_button:DefaultButton;

		private var login_email_input:DefaultInputfield;

		private var login_email_button:DefaultButton;

		private var login_password_input:DefaultInputfield;

		private var register_email_nickname_input:DefaultInputfield;

		private var register_email_email_input:DefaultInputfield;

		private var register_email_password_input:DefaultInputfield;

		private var register_email_submit_button:DefaultButton;
		
		public function Startscreen()
		{
			super();
			var scale:Number = 1;
			backgroundTexture = Texture.fromBitmap(new Assets.CowBG(),false,false,scale);
			
		}

		public override function init():void{
			game = Game.getGame();
			textField = new TextField(game.stageWidth, game.stageHeight, "Hi");
			addChild(textField);
			
			// init background
			backgroundImage = new Image(backgroundTexture);
			backgroundImage.height = backgroundImage.height / (backgroundImage.width / game.stageWidth);
			backgroundImage.width = game.stageWidth;		
			addChild(backgroundImage);
			animateBackgroundToBottom();

			// init logo
			logo = new Image(game.assets.textureAtlas1.getTexture("logo"));
			var logoOriginalWidth:Number = logo.width;
			logo.width = game.stageWidth * 0.8;
			logo.height = logo.height * (logo.width/logoOriginalWidth);
			
			logo.x = (game.stageWidth-logo.width) / 2;
			logo.y = game.stageHeight * 0.10;
			addChild(logo);
			
			//init cards
			
			
			var card_animal:Image = new Image(game.assets.cardTextureAtlas.getTexture('cow'));
			addChild(card_animal);
			card_animal.scaleY = card_animal.scaleX = game.stageHeight / (640/ 1);
			card_animal.x = -card_animal.width * 0.05;
			card_animal.y = game.stageHeight - card_animal.height * 0.90;
			card_animal.rotation = deg2rad(-10);
			
			var card_money:Image = new Image(game.assets.textureAtlas1.getTexture("money_home"));
			addChild(card_money);
			card_money.scaleY = card_money.scaleX =  game.stageHeight / (640/ 1);
			card_money.y = game.stageHeight - card_money.height * 0.90;
			card_money.x = game.stageWidth - card_money.width * 0.95;
			card_money.rotation = deg2rad(10);
			
			TweenLite.from(card_animal, 2.4, {y:game.stageHeight, rotation:0});
			TweenLite.from(card_money, 2.4, {delay:1, y:game.stageHeight, rotation:0});
			
			//init startscreen buttons
			play_button = new DefaultButton(game.stageWidth * 0.28, game.stageWidth * 0.10,"Spelen",13);
			play_button.x = game.stageWidth / 2;
			play_button.y = game.stageHeight*0.6;
			play_button.addEventListener(TouchEvent.TOUCH,playButtonListener);
			addChild(play_button);
			
			explain_button = new DefaultButton(game.stageWidth * 0.22, game.stageWidth * 0.08,"Uitleg",12);
			explain_button.x = game.stageWidth / 2;
			explain_button.y = game.stageHeight*0.8;
			explain_button.addEventListener(TouchEvent.TOUCH,explainButtonListener);
			addChild(explain_button);
			
		}
		
		private function explainButtonListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				game.gotoScreen('menu');
				var menu:Menu = game.showingScreen as Menu;
				menu.setMenuView('uitleg');
			}
		}	
	
		private function playButtonListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				game.gotoScreen('menu');
			}
		}
		
		private function animateBackgroundToBottom():void{
			TweenLite.to(backgroundImage,backgroundScrollSpeed/1000,{y:-(backgroundImage.height-game.stageHeight), onComplete:animateBackgroundToTop,ease:Cubic.easeInOut});
		}
		
		private function animateBackgroundToTop():void{
			TweenLite.to(backgroundImage,backgroundScrollSpeed/1000,{y:0, ease:Cubic.easeInOut});
			setTimeout(function():void{
				animateBackgroundToBottom();
			},backgroundScrollSpeed);
		}
		

		public override function prepareForDeletion():void{
			trace('removeStartscreen');
			play_button.removeEventListener(TouchEvent.TOUCH,playButtonListener);
			explain_button.removeEventListener(TouchEvent.TOUCH,explainButtonListener);
		}
		
	}
}