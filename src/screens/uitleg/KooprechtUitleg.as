package screens.uitleg
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import components.DisplayAnimalCard;
	
	import configuration.Config;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;

	public class KooprechtUitleg extends UitlegScreen
	{

			private var animalCard:DisplayAnimalCard;
			public function KooprechtUitleg(title:String)
			{
				super(title);
				
				animalCard = new DisplayAnimalCard('animal_back',true);
				animalCard.y = game.stageHeight * 0.4;
				animalCard.scaleX = animalCard.scaleY = 0.7;
				animalCard.x = this.uitlegOffset + animalCard.width/2;
				addChild(animalCard);
				
				var description:TextField = new TextField(this.uitlegWidth * 0.65, game.stageHeight * 0.5,"",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
				description.x = this.uitlegWidth * 0.25 + this.uitlegOffset;
				description.hAlign = 'left';
				description.vAlign = 'top';
				description.y = game.stageHeight * 0.2;
				description.text = "De veiler mag het dier kopen voor het hoogste bod. \n\nKoopt hij het dier? Dan krijgt de hoogste bieder het geld.";
				addChild(description);
				
			}
			
			public override function animateIn():void{
				shakeTween(animalCard,30);
			}
			public override function resetAnimateIn():void{
				TweenLite.killTweensOf(animalCard);
			}
			private function shakeTween(item:DisplayObject, repeatCount:int):void
			{
				var initPoint:Point = new Point(item.x, item.y);
				var x:int = 0;
				var interval:uint = setInterval(function():void{
					TweenLite.to(item,0.1,{x:initPoint.x + (Math.random() * -8) + 4,y:initPoint.y + (Math.random() * -8) + 4});
					x++;
					if(x == repeatCount){
						clearInterval(interval);
						TweenLite.to(item,0.1,{x:initPoint.x, y:initPoint.y});
					}
				},100);
			}
		}
	}


