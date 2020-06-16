package components
{
	import configuration.Config;
	
	import screens.Menu;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class SideMenu extends Sprite
	{

		private var game:Game;

		private var menuWidth:Number;
		public function SideMenu()
		{
			super();
			
			game = Game.getGame();
			menuWidth = game.stageWidth * 0.41;
			var menuPadding:Number = menuWidth * 0.04;
			
			var menuBG:Image = new Image(Texture.fromColor(menuWidth,game.stageHeight,Config.redColorRGBA,false, 1));
			addChild(menuBG);
			
			//init menu items
			var singlePlayerMenuItem:SideMenuItem = new SideMenuItem(game.assets.textureAtlas1.getTexture('menu_icon_hammer'),menuWidth,menuPadding,"SINGLE PLAYER");
			singlePlayerMenuItem.addEventListener(TouchEvent.TOUCH, clickSinglePlayer);
			addChild(singlePlayerMenuItem);

			var helpMenuItem:SideMenuItem = new SideMenuItem(game.assets.textureAtlas1.getTexture('menu_icon_questionmark'),menuWidth,menuPadding,"UITLEG");
			helpMenuItem.y = singlePlayerMenuItem.height + singlePlayerMenuItem.y;
			helpMenuItem.addEventListener(TouchEvent.TOUCH, clickHelp);

			addChild(helpMenuItem);
			
			
		}
		
		private function clickSinglePlayer(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				if(game.showingScreenName == 'menu'){
					var menu:Menu = game.showingScreen as Menu;
					menu.setMenuView('singleplayer');
				}
			}
		}
		private function clickHelp(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				if(game.showingScreenName == 'menu'){
					var menu:Menu = game.showingScreen as Menu;
					menu.setMenuView('uitleg');
				}
			}
		}
	}
}