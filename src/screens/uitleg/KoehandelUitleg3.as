package screens.uitleg
{
	import com.greensock.TweenLite;
	
	import components.DisplayMoneyCard;
	
	import configuration.Config;
	
	import starling.text.TextField;
	
	public class KoehandelUitleg3 extends UitlegScreen
	{
		
		private var moneyCards:Array;
		public function KoehandelUitleg3(title:String)
		{
			super(title);
			
			moneyCards = [];
			
			for(var x:int = 0; x < 3; x ++){
				var moneyCard:DisplayMoneyCard = new DisplayMoneyCard('money_back',true);
				moneyCard.y = game.stageHeight * 0.4;
				moneyCard.scaleX = moneyCard.scaleY = 0.6;
				moneyCard.x = this.uitlegOffset + moneyCard.width/2;
				addChild(moneyCard);
				moneyCards.push(moneyCard);
			}
			
			var description:TextField = new TextField(this.uitlegWidth * 0.65, game.stageHeight * 0.65,"",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
			description.x = this.uitlegWidth * 0.25 + this.uitlegOffset;
			description.hAlign = 'left';
			description.vAlign = 'top';
			description.y = game.stageHeight * 0.2;
			description.text = "De speler met het hoogste bod wint de dieren.\n\nLet op: wanneer beide spelers 2 dieren bezitten gaat het altijd om 4 dieren!";
			addChild(description);
			
		}
		
		public override function animateIn():void{
			var rotationValues:Array = [-0.3,0,0.3];
			var xValues:Array = [-10,0,10];
			for(var x:int in moneyCards){
				var moneyCard:DisplayMoneyCard = moneyCards[x];					
				TweenLite.to(moneyCard,0.6,{rotation:rotationValues[x], x: moneyCard.x + xValues[x]});
			}
		}
		public override function resetAnimateIn():void{
			for(var x:int in moneyCards){
				var moneyCard:DisplayMoneyCard = moneyCards[x];					
				moneyCard.rotation = 0;
				moneyCard.x = this.uitlegOffset + moneyCard.width/2;
			}
		}
		
	}
}



