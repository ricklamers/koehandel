package screens
{
	import com.greensock.TweenLite;
	
	import components.SideMenu;
	
	import configuration.Config;
	
	import interfaces.GameScreen;
	
	import screens.menu.SinglePlayer;
	import screens.menu.Uitleg;
	import screens.menu.Uitslag;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Menu extends GameScreen
	{

		private var game:Game;

		private var menuBarButton:Sprite;

		private var menuBarButtonBG:Image;

		private var mainContainer:Sprite;

		private var menuContainer:Sprite;

		private var menuOpen:Boolean;

		private var currentMenuView:GameScreen;

		private var menuView:Sprite;

		public var menuViewName:String;

		private var menuBarTitle:TextField;
		
		public function Menu()
		{
			super();
			
			game = Game.getGame();
			
			mainContainer = new Sprite();
			menuContainer = new Sprite();
			menuOpen = false;
			
			// init background
			var backgroundImage:Image = new Image(game.assets.mainBG);
			backgroundImage.height = backgroundImage.height / (backgroundImage.width / game.stageWidth);
			backgroundImage.width = game.stageWidth;
			
			if((game.stageWidth/game.stageHeight) < (backgroundImage.width/backgroundImage.height)){
				// aspect ratio is more square, make height base and center image
				backgroundImage.width = backgroundImage.width / (backgroundImage.height/game.stageHeight);
				backgroundImage.height = game.stageHeight;
				backgroundImage.x = -(backgroundImage.width - game.stageWidth)/2;
			}
			
			var mainContainerShadow:Image = new Image(Texture.fromColor(4,game.stageHeight, 0x99000000,false,1));
			mainContainerShadow.x = game.stageWidth - 0.5;
			mainContainer.addChild(mainContainerShadow);
			mainContainer.addChild(backgroundImage);
			
			// init menu bar
			var menuBar:Image = new Image(game.assets.menuBarTexture);
			
			//init menuViewContainer
			menuView = new Sprite();
			menuView.y = menuBar.height;
			mainContainer.addChild(menuView);
			mainContainer.addChild(menuBar);
			
			menuBarButton = new Sprite();
			menuBarButtonBG = new Image(Texture.fromColor(game.stageHeight * Config.menuHeight,game.stageHeight * Config.menuHeight,0xff950005,false, 1));
			menuBarButtonBG.alpha = 0;
			var menuBarIcon:Image = new Image(game.assets.textureAtlas1.getTexture('menu_button'));
			menuBarIcon.width = menuBarButtonBG.width * 0.6;
			menuBarIcon.height = menuBarButtonBG.width * 0.6;
			menuBarIcon.y = (menuBarButtonBG.height - menuBarIcon.height) / 2;
			menuBarIcon.x = (menuBarButtonBG.width - menuBarIcon.width) / 2;
			menuBarButton.addChild(menuBarButtonBG);
			menuBarButton.addChild(menuBarIcon);			
			menuBarButton.x = game.stageWidth - menuBarButton.width;
			menuBarButton.addEventListener(TouchEvent.TOUCH, menuBarButtonListener);
			mainContainer.addChild(menuBarButton);
			
			
			menuBarTitle = new TextField(game.stageWidth - menuBarButton.width*2,game.stageHeight*Config.menuHeight * 0.9,"SINGLE PLAYER",Config.fontName,21*Config.fontScaling,0xffffff);
			menuBarTitle.x = menuBarButton.width;
			menuBarTitle.y = menuBarButton.height * 0.1;
			mainContainer.addChild(menuBarTitle);
			
			
			var sideMenu:SideMenu = new SideMenu();
			menuContainer.addChild(sideMenu);
			menuContainer.x = game.stageWidth * 0.59;
			addChild(menuContainer);
			addChild(mainContainer);
			
			//init singleplayerview
			setMenuView('singleplayer');
			
		}
		
		private function menuBarButtonListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				menuBarButtonBG.alpha = 1;
			}
			if(touch.phase == TouchPhase.ENDED){
				game.assets.buttonSound.play();
				menuBarButtonBG.alpha = 0;
				toggleMenu();
			}
		}
		
		public function toggleMenu():void
		{
			if(menuOpen){
				menuOpen = !menuOpen;
				TweenLite.to(mainContainer,0.3,{x:0});
			}else{
				menuOpen = !menuOpen;
				TweenLite.to(mainContainer,0.3,{x:-game.stageWidth * 0.40});
			}
		}
		public function setMenuView(newMenuView:String, argument1:* = null):void{
			if(newMenuView != menuViewName){
				menuView.removeChild(currentMenuView,true);
				menuViewName = newMenuView;
				switch(newMenuView){
					case "singleplayer":
						currentMenuView = new SinglePlayer();
						break;
					case "uitleg":
						currentMenuView = new Uitleg();
						break;
					case "uitslag":
						currentMenuView = new Uitslag(argument1);
						break;
				}
				
				menuBarTitle.text = currentMenuView.screenTitle.toUpperCase();
				menuView.addChild(currentMenuView);
				
			}
			if(menuOpen){
				toggleMenu();
			}
		}
	}
}