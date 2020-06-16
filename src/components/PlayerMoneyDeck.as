package components
{
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class PlayerMoneyDeck extends Sprite
	{

		private var cardCount:TextField;
		public function PlayerMoneyDeck()
		{
			super();
			var game:Game = Game.getGame();
			var deckImage:Image = new Image(game.assets.cardTextureAtlas.getTexture("money_back"));
			
			deckImage.width = (deckImage.width / 4) * 1;
			deckImage.height = (deckImage.height / 4) * 1;
			addChild(deckImage);
			cardCount = new TextField(deckImage.width, deckImage.height*0.4,"", Config.fontName,14*Config.fontScaling,Config.yellowColor);
			cardCount.y = deckImage.height * 0.6;
			cardCount.x = 0;
			addChild(cardCount);
			
		}
		public function changeDeckCount(value:Number):void{
			cardCount.text = ""+value;
		}
	}
}