package components
{
	import com.greensock.TweenLite;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.utils.setTimeout;
	
	import managers.Assets;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class DonkeyBackground extends Sprite
	{
		public function DonkeyBackground()
		{
			super();
			var game:Game = Game.getGame();
			var donkeyBackground:Image = new Image(game.assets.textureAtlas1.getTexture("uitleg_donkey"));
			donkeyBackground.scaleX = donkeyBackground.scaleY = 1;
			donkeyBackground.blendMode = BlendMode.ADD;
			donkeyBackground.x = -donkeyBackground.width * 0.5;
			donkeyBackground.y = -donkeyBackground.height * 0.5;
			addChild(donkeyBackground);
			
			// instantiate embedded objects
			var psConfig:XML = XML(new Assets.MoneyParticleConfig());
			var psTexture:Texture = Texture.fromBitmap(new Assets.MoneyParticle());
			
			// create particle system
			var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
			ps.x = game.stageWidth /2 + 30;
			ps.y = game.stageHeight /2;
//			ps.blendFactorSource = Context3DBlendFactor.SOURCE_COLOR;
//			ps.blendFactorDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			
			// add it to the stage and the juggler
			game.singlePlayerGameScreen.addChild(ps);
			Starling.juggler.add(ps);

			// emit particles for two seconds, then stop
			setTimeout(function():void{
				ps.start(4.0);
			},1000);
			
			TweenLite.to(ps,1,{alpha:0, delay:3.5});
			
			setTimeout(function():void{
				game.singlePlayerGameScreen.removeChild(ps);
			},5000);
			
		}
	}
}