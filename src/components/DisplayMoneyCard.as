package components
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class DisplayMoneyCard extends Image
	{
		private var _name:String;
		public var draggable:Boolean = true;
		public function DisplayMoneyCard(moneyCard:String, centered:Boolean = true)
		{
			var game:Game = Game.getGame();
			var texture:Texture = game.assets.cardTextureAtlas.getTexture(moneyCard);
			super(texture);
			
			if(centered){
				pivotY = height/2;
				pivotX = width/2;
			}
			
			width = (width / 4) * 1;
			height = (height / 4) * 1;
			_name = moneyCard;
			
			
		}
		public function getName():String{
			return _name;
		}
	}
}