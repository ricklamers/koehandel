package components
{
	
	import configuration.Config;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class AuctionBord extends Sprite
	{
		public var scoreField:TextField;
		public function AuctionBord()
		{
			super();
			var game:Game = Game.getGame();
			var boardImage:Image = new Image(game.assets.textureAtlas1.getTexture("auction_board"));

			scoreField = new TextField(boardImage.width,boardImage.height/3,"0",Config.fontName,18*Config.fontScaling,0x000000);
			addChild(boardImage);
			scoreField.y = boardImage.height * 0.15;
			addChild(scoreField);

		}
	}
}