package components
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class DisplayAnimalCard extends Image
	{
		private var _name:String = "";
		public function DisplayAnimalCard(animalName:String, centered:Boolean = true)
		{
			var game:Game = Game.getGame();
			var texture:Texture = game.assets.cardTextureAtlas.getTexture(animalName);
			super(texture);
			

			_name = animalName;
			
			if(centered){
				pivotY = height/2;
				pivotX = width/2;
			}
			
			width = (width / 4) * 1;
			height = (height / 4) * 1;

			
			
		}
		public function getName():String{
			return _name;
		}
	}
}