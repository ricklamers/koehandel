package screens.uitleg
{
	
	import com.greensock.TweenLite;
	
	import components.DisplayAnimalCard;
	
	import configuration.Config;
	
	import starling.text.TextField;

	public class DoelUitleg extends UitlegScreen
	{

		private var animalArray:Array;
		public function DoelUitleg(title:String)
		{
			super(title);
			
			animalArray = [];
			
			for(var x:int = 0; x < 4; x++){
				var animalCard:DisplayAnimalCard = new DisplayAnimalCard('goat',true);
				animalCard.scaleX = animalCard.scaleY = 0.70;
				animalCard.x = this.uitlegOffset + animalCard.width;
				//	animalCard.y = game.stageHeight * 0.4 + (x * 3);
				animalCard.y = game.stageHeight * 0.4;
				addChild(animalCard);
				animalArray.push(animalCard);
			}
			
			var description:TextField = new TextField(this.uitlegWidth * 0.65, game.stageHeight * 0.5,"",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
			description.x = this.uitlegWidth * 0.35 + this.uitlegOffset;
			description.hAlign = 'left';
			description.vAlign = 'top';
			description.y = game.stageHeight * 0.3;
			description.text = "Verzamel zo veel mogelijk  dierkwartetten.";
			addChild(description);
			
		}
		
		public override function animateIn():void{
			var animalCard:DisplayAnimalCard = animalArray[0];
			TweenLite.to(animalCard,0.3,{y:game.stageHeight * 0.4 - 9, delay:0.2});
			animalCard = animalArray[1];
			TweenLite.to(animalCard,0.3,{y:game.stageHeight * 0.4 - 6, delay:0.1});
			animalCard = animalArray[2];
			TweenLite.to(animalCard,0.3,{y:game.stageHeight * 0.4 - 3, delay:0});
		}
		public override function resetAnimateIn():void{
			for(var x:int in animalArray){
				var animalCard:DisplayAnimalCard = animalArray[x];
				animalCard.y = game.stageHeight * 0.4;
			}
		}
	}
}