package model
{
	import events.GameEvent;

	public class UserPlayer extends Player
	{

		private var g:SinglePlayerModel;

		public var tradeProcess_fromPlayer:Player;
		public var tradeProcess_animal:AnimalCard;
		public var tradeProcess_doubleTrade:Boolean;
		public var tradeProcess_offer:Number;
		
		public function UserPlayer(r_name:String,playerImageName:String='chicken_icon')
		{
			super(r_name, playerImageName);
			g = SinglePlayerModel.currentGame;
			
		}
		
		public override function requestTurnChoice():void{
			if(g.getAnimalDeck().length == 0 && super.canTradeAnimal()){
				// start trade
				determineTrade();
			} else if(g.getAnimalDeck().length > 0 && !super.canTradeAnimal()){
				g.auctionAnimal(this);
			} else if(g.getAnimalDeck().length > 0 && super.canTradeAnimal()){
				//notify UI, determine what to do
				g.dispatchEvent(new GameEvent(GameEvent.RequestTurnOption,{}));	

			}
			else{
				trace(super.canTradeAnimal());
				g.skipTurn(this);
			}			
		}
		
		public override function requestAuctionBid():void{
			//not needed for real player
		}
		
		public function makeOffer(offer:Number):void{
			if(offer <= countMoney() && g.getHighestBidder() != this){
				g.makeOffer(this,offer);
			}
		}
		public function determineTrade():void{
			g.dispatchEvent(new GameEvent(GameEvent.RequestTradePartner,{'animalCandidates':super.animalTradeCandidates,'playerCandidates':super.tradeCandidates}));			
		}
		
		public override function requestCounterTrade(fromPlayer:Player, animal:AnimalCard, offer:Number, doubleTrade:Boolean):void{
			
			//determine what to do
			
			//set info for this trade
			tradeProcess_fromPlayer = fromPlayer;
			tradeProcess_animal = animal;
			tradeProcess_doubleTrade = doubleTrade;
			tradeProcess_offer = offer;
			
			g.dispatchEvent(new GameEvent(GameEvent.RequestTradeCounterOffer,{'offer':offer,'player':fromPlayer,'animal':animal, 'doubleTrade':doubleTrade}));
			
			
		}
		public function acceptTradeOffer():void{
			g.takeOfferedTrade(this, tradeProcess_animal, tradeProcess_doubleTrade);
		}
		public function makeCounterOffer(counterOffer:Array):void{
			g.makeCounterOffer(this, tradeProcess_animal, tradeProcess_doubleTrade, counterOffer);
		}
		
		public function makeTrade(tradePartner:Player, animal:AnimalCard, offer:Array):Boolean{
			
			var doubleTrade:Boolean = false;
			
			if(CardManager.checkAmountForName(animal.getAnimalName(),this.animalCards) == 2
				&& CardManager.checkAmountForName(animal.getAnimalName(), tradePartner.animalCards) == 2){
				// trade for 2 because receiver and offerer both have 2
				doubleTrade = true;
				trace('NOW TRADING FOR DOUBLE ANIMALS');		
			}
			
			g.offerTrade(this, tradePartner,animal,offer.length, offer, doubleTrade);
			
			return true;
		}
		
		public override function requestBuyOption(highestBid:Number, highestBidHolder:Player):void{
			if(highestBid <= super.countMoney() && highestBid > 0){
				g.dispatchEvent(new GameEvent(GameEvent.RequestBuyOption,{}));	
			}else if(highestBid == 0){
				g.auctionerBuysAnimal();
			}else{
				g.auctionerSellsAnimal();
			}
			
		}
		public function chooseAuctionTurn():void{
			g.auctionAnimal(this);
		}
		public function chooseTradeTurn():void{
			determineTrade();
		}
		
		public function buyAuctionAnimal():void{
			g.auctionerBuysAnimal();
		}
		public function sellAuctionAnimal():void{
			g.auctionerSellsAnimal();
		}
		
		public function determineTurnChoice(choice:String):void{
			
			switch(choice){
				case "auction":
					g.auctionAnimal(this);
					break;
				case "trade":
					super.determineBestTrade();
					break;
			}
		}
	}
}