package components
{
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class SideMenuItem extends Sprite
	{

		private var menuItemBG:Image;

		private var game:Game;
		public function SideMenuItem(imageTexture:Texture, menuWidth:Number, menuPadding:Number, text:String)
		{
			super();
			game = Game.getGame();
			
			var menuItemHeight:Number = game.stageHeight * Config.menuHeight - menuPadding * 2;
			var menuItemBGTexture:Texture = Texture.fromColor(menuWidth,menuItemHeight + menuPadding * 2,Config.darkRedColorRGBA,false, 1);

			//single player menu item
			var menuItemIcon:Image = new Image(imageTexture);
			menuItemBG = new Image(menuItemBGTexture);
			addChild(menuItemBG);
			menuItemBG.visible = true;
			menuItemBG.alpha = 0;
			
			// initial width
			var previousWidth:Number = menuItemIcon.width;
			menuItemIcon.width = menuItemBG.height * 0.7;
			menuItemIcon.height = menuItemIcon.height * (menuItemIcon.width / previousWidth);
			menuItemIcon.x = menuPadding * 1.5;
			
			addChild(menuItemIcon);
			var menuItemText:TextField = new TextField(menuWidth - menuPadding * 2 - menuItemIcon.width, menuItemHeight ,text,Config.fontName, 14*Config.fontScaling, 0xffffff);
			menuItemText.y = menuPadding;
			menuItemIcon.y = menuPadding;
			menuItemText.hAlign = "left";
			menuItemText.x = menuPadding * 2 + menuItemIcon.width;
			addChild(menuItemText);	
			
			addEventListener(TouchEvent.TOUCH, touchMenuItem);
			
		}
		
		private function touchMenuItem(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				menuItemBG.alpha = 1;
			}
			if(touch.phase == TouchPhase.ENDED){
				menuItemBG.alpha = 0;
				game.assets.buttonSound.play();
			}
		}
	}
}