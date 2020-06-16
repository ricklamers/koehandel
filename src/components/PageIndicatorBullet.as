package components
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class PageIndicatorBullet extends starling.display.Sprite
	{

		private var circleImage:Image;

		private var game:Game;

		public function PageIndicatorBullet(bulletSize:Number)
		{		
			game = Game.getGame();
			circleImage = new Image(game.assets.whiteCircleTexture);
			addChild(circleImage);
			
		}
		public function makeActive():void{
			circleImage.texture = game.assets.redCircleTexture;
		}
		
		public function makeInactive():void
		{
			circleImage.texture = game.assets.whiteCircleTexture;
		}
	}
}