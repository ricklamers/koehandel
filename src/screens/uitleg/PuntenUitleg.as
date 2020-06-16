package screens.uitleg
{
	import configuration.Config;
	
	import starling.display.Image;
	import starling.text.TextField;
	
	public class PuntenUitleg extends UitlegScreen
	{
		
		public function PuntenUitleg(title:String)
		{
			super(title);
			
			var puntenImage:Image = new Image(game.assets.textureAtlas1.getTexture("uitleg_points"));
			puntenImage.x = (game.stageWidth - puntenImage.width )/ 2;
			puntenImage.y = game.stageHeight * 0.20;
			addChild(puntenImage);
			
			var description:TextField = new TextField(this.uitlegWidth, game.stageHeight * 0.5,"",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
			description.x = this.uitlegOffset;
			description.y = game.stageHeight * 0.3;
			description.text = "350 + 1000 = 1350\n1350 x 2 kwartetten = 2700";
			addChild(description);
			
		}
		
		public override function animateIn():void{
			
		}
		public override function resetAnimateIn():void{
			
		}
		
	}
}

