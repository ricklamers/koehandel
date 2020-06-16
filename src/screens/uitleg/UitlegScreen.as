package screens.uitleg
{
	import configuration.Config;
	
	import interfaces.GameScreen;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class UitlegScreen extends GameScreen
	{

		public var uitlegWidth:Number;
		public var uitlegOffset:Number;
		public var game:Game;
		
		public function UitlegScreen(title:String)
		{
			super();
			
			game = Game.getGame();
			
			var touchableArea:Image = new Image(Texture.fromColor(1,1,0x00000000,false,1));
			touchableArea.width = game.stageWidth;
			touchableArea.height = game.stageHeight;
			addChild(touchableArea);
			
			var uitlegViewTitle:TextField = new TextField(game.stageWidth, game.stageHeight * 0.1, title, Config.fontStrokedName, 24*Config.fontScaling, 0xffffff);
			uitlegViewTitle.y = game.stageHeight * 0.05;
			addChild(uitlegViewTitle);
			
			uitlegWidth = game.stageWidth * 0.8;
			uitlegOffset = (game.stageWidth - uitlegWidth) / 2; 
			
		}
		public function animateIn():void{
			
		}
		public function resetAnimateIn():void{
			
		}
	}
}