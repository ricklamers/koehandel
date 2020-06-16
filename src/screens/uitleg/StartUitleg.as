package screens.uitleg
{
	import com.greensock.TweenLite;
	
	import components.DisplayMoneyCard;
	
	import configuration.Config;
	
	import starling.text.TextField;

	public class StartUitleg extends UitlegScreen
	{

		private var baseLeftDistance:Number;

		private var moneyCards:Array;

		private var moneyCardSpace:Number;
		public function StartUitleg(title:String)
		{
			super(title);
			
			moneyCards = [];
			
			var description:TextField = new TextField(this.uitlegWidth, game.stageHeight * 0.1,"Iedere speler ontvangt:",Config.fontStrokedName,18*Config.fontScaling,0xffffff);
			description.y = game.stageHeight * 0.2;
			description.x = this.uitlegOffset;
			addChild(description);
			
			var moneyCardArray:Array = [50,10,10,10,10,0,0];
			moneyCardSpace = (this.uitlegWidth * 0.7) / moneyCardArray.length;
			
			//for money card width
			var moneyCard:DisplayMoneyCard = new DisplayMoneyCard("0");
			
			baseLeftDistance = this.uitlegOffset + this.uitlegWidth * 0.15 + (moneyCard.width/2);
			
			for(var x:int in moneyCardArray){
				moneyCard = new DisplayMoneyCard(moneyCardArray[x]+"");
				moneyCard.x = baseLeftDistance + moneyCardSpace * x - moneyCard.width/2;
				moneyCard.alpha = 0;
				moneyCard.y = game.stageHeight * 0.5;
				moneyCards.push(moneyCard);
				addChild(moneyCard);
			}
			
		}
		
		public override function animateIn():void{
			var delay:Number = 0;
			for(var x:int in moneyCards){
				var moneyCard:DisplayMoneyCard = moneyCards[x];
				TweenLite.to(moneyCard,0.3,{delay:delay,alpha:1, x: baseLeftDistance + moneyCardSpace * x});
				delay += 0.1;
			}
		}
		public override function resetAnimateIn():void{
			for(var x:int in moneyCards){
				var moneyCard:DisplayMoneyCard = moneyCards[x];
				moneyCard.alpha = 0;
				moneyCard.x = baseLeftDistance + moneyCardSpace * x - moneyCard.width/2;
			}
		}
	}
}