package screens.uitleg
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.utils.setTimeout;
	
	import components.DisplayAnimalCard;
	
	import configuration.Config;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.text.TextField;
	
	public class EzelUitleg extends UitlegScreen
	{
		
		private var animalCard:DisplayAnimalCard;

		private var active:Boolean;

		private var backgroundImage:Image;
		public function EzelUitleg(title:String)
		{
			super(title);
			
			animalCard = new DisplayAnimalCard('donkey',true);
			animalCard.y = game.stageHeight * 0.4;
			animalCard.scaleX = animalCard.scaleY = 0.7;
			animalCard.x = this.uitlegOffset + animalCard.width/2;
			
			
			backgroundImage = new Image(game.assets.textureAtlas1.getTexture("uitleg_donkey"));
			backgroundImage.scaleX = backgroundImage.scaleY = 1.3;
			backgroundImage.blendMode = BlendMode.ADD;
			backgroundImage.y = animalCard.y - backgroundImage.height * 0.5;
			backgroundImage.x = animalCard.x - backgroundImage.width * 0.5;
			addChild(backgroundImage);
			addChild(animalCard);
			
			var description:TextField = new TextField(this.uitlegWidth * 0.65, game.stageHeight * 0.5,"",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
			description.x = this.uitlegWidth * 0.25 + this.uitlegOffset;
			description.hAlign = 'left';
			description.vAlign = 'top';
			description.y = game.stageHeight * 0.2;
			description.text = "Wanneer de ezel wordt geveild ontvangt iedereen geld.\n\nEerst 50, dan 100, 200 en tot slot 500!";
			addChild(description);
			
		}
		
		public override function animateIn():void{
			active = true;
			animateAlpha();
			
			setTimeout(function():void{
				active = false;
			},1500);
		}
		public override function resetAnimateIn():void{
			active = false;
		}
		private function animateAlpha():void{
			TweenLite.to(backgroundImage,0.1,{alpha:1, ease:Cubic.easeInOut, onComplete:function():void{
				TweenLite.to(backgroundImage,0.1,{alpha:0.4,ease:Cubic.easeInOut, onComplete:function():void{
					if(active){
						animateAlpha();
					}
				}});
			}});
		}

	}
}

