package model
{
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import configuration.Config;
	
	import events.GameEvent;

	public class SinglePlayerModel extends EventDispatcher
	{
		public static const TurnType_AUCTION:String = "auction";
		public static const TurnType_TRADE:String = "trade";
		public static const TurnType_SKIP:String = "pass";
		public static const DonkeyRewards:Array = [50,100,200,500];
		public static var currentGame:SinglePlayerModel;


		private var animalCardDeck:Array;
		private var currentPlayer:Player;
		private var auctionedAnimal:AnimalCard;
		private var auctionTimeLeft:Number = -1;
		private var highestBid:Number = 0;
		private var auctionTimer:uint; 
		private var auctionTimerInterval:uint;
		private var highestBidHolder:Player;
		private var cpuPlayers:Array;
		private var players:Array;
		private var currentPlayerOffer:Array;
		public var difficulty:int;
		public var donkeyCount:int = 0;
		public var yourself:UserPlayer;
		public var gameMoneyAverage:int = 90;
		public var cardManager:CardManager;

		private var turnTimeout:uint;

		private var startGameInterval:int;
		
		public function SinglePlayerModel(difficulty:int) 
		{
			this.difficulty = difficulty;
		}
		public function init():void{
			currentGame = this;
			
			//card manager
			cardManager = new CardManager();
			
			//init player
			var player:UserPlayer = new UserPlayer('Jij','farmer3');
			player.moneyCards = cardManager.getStartingMoneyCards();
			
			//init cpus
			var cpu1:Player = new Player('Mevrouw Bep','farmer1');
			cpu1.moneyCards = cardManager.getStartingMoneyCards();
			
			var cpu2:Player = new Player('Boer Harm','farmer2');
			cpu2.moneyCards = cardManager.getStartingMoneyCards();
			
			var cpu3:Player = new Player('Boer Willem','farmer4');
			cpu3.moneyCards = cardManager.getStartingMoneyCards();
			
			cpuPlayers = [cpu1,cpu2,cpu3];
			
			yourself = player;
			
			
			players = [player, cpu1, cpu2, cpu3];
			
			// deck initialize
			animalCardDeck = cardManager.getAnimalDeck();	
			dispatchEvent(new GameEvent(GameEvent.DeckPrepared,{'deckCount':animalCardDeck.length}));
			
			// determine first player
			
			if(difficulty > Config.GameDifficulty_HARD){
				currentPlayer = players[Math.round(Math.random() * (players.length-1))];
			}else{
				// player always starts first with normal
				currentPlayer = players[0];
			}
			
			
			
			trace(currentPlayer.getName()+' is up first!');
			
			newTurn();
		}
		
		public function getDeck():Array{
			return this.animalCardDeck;
		}
		
		private function newTurn():void
		{
	
			trace('Slow down game, wait for 1 acution duration');
			dispatchEvent(new GameEvent(GameEvent.NewTurn,{'player':currentPlayer}));
			
			turnTimeout = setTimeout(function():void{
				
				
				
				if(animalCardDeck.length > 0 || !unresolvedSets()){
					currentPlayer.requestTurnChoice();
				}else{
					trace('Game is done! :D');
					
					trace('This is the end state:');
					
					//loop through animals of tradePartner
					for(var x:int in players){
						var animalList:String = "";
						var playerScore:Number = 0;
						var animals:Array = [];
						for(var u:int in (players[x] as Player).animalCards){
							var thisAnimal:AnimalCard = ((players[x] as Player).animalCards[u] as AnimalCard);
							animalList += thisAnimal.getAnimalName() + ' , ';
							if(animals.indexOf(thisAnimal.getAnimalName()) == -1){
								// first time I see this animal
								playerScore += thisAnimal.getAnimalValue();
								animals.push(thisAnimal.getAnimalName());
							}
						}
						playerScore *= animals.length;
						(players[x] as Player).totalScore = playerScore;
						trace((players[x] as Player).getName()+ ' has: '+ animalList);
						trace((players[x] as Player).getName() + 'scored: ' + playerScore);
					}
					
					dispatchEvent(new GameEvent(GameEvent.GameEnded,{}));

				}
				
			},Config.auctionLength/2);
			
		}
		public function getAnimalDeck():Array{
			return animalCardDeck;
		}
		public function unresolvedSets():Boolean{
			//loop through players
			for(var x:int in players){
				var checkedAnimalNames:Array = [];
				for(var y:int in (players[x] as Player).animalCards){
					var currentAnimal:AnimalCard = (players[x] as Player).animalCards[y];
					if(checkedAnimalNames.indexOf(currentAnimal.getAnimalName()) == -1){
						checkedAnimalNames.push(currentAnimal.getAnimalName());
						if(CardManager.checkAmountForName(currentAnimal.getAnimalName(), (players[x] as Player).animalCards) < 4){
							return false;
						}
					}
				}
			}
			return true;	
		}
		public function getAuctionedAnimal():AnimalCard{
			return auctionedAnimal;
		}
		public function auctionAnimal(ownerPlayer:Player):void {
			//get animal from deck
			auctionedAnimal = animalCardDeck.pop();
			
			
			trace('Auction of: '+(auctionedAnimal as AnimalCard).getAnimalName()+ ' START!');
			trace(animalCardDeck.length + 'cards left in the deck');
			if((auctionedAnimal as AnimalCard).getAnimalName() == 'donkey'){
				giveMoneyForDonkey();
			}
			
			highestBid = 0;
			highestBidHolder = ownerPlayer;
			
			dispatchEvent(new GameEvent(GameEvent.AuctionOffer,{'offer':highestBid, 'player':highestBidHolder}));

			
			resetAuctionTimer();
			
			//notify players about bid oppurtunity
			notifyPlayersOfAuction();
			dispatchEvent(new GameEvent(GameEvent.CardDrawn,{'animal':auctionedAnimal.getAnimalName(),'seller':ownerPlayer}));
			
		}
		
		private function giveMoneyForDonkey():void
		{
			for(var x:int in players){
				(players[x] as Player).moneyCards.push(new MoneyCard(SinglePlayerModel.DonkeyRewards[donkeyCount]));
			}
			gameMoneyAverage += DonkeyRewards[donkeyCount];
			donkeyCount++;
			dispatchEvent(new GameEvent(GameEvent.MoneyUpdated,{}));
		}
		
		private function notifyPlayersOfAuction():void
		{
			for(var i:int in players){
				if(players[i] != currentPlayer){
					(players[i] as Player).requestAuctionBid();
				}
			}
		}
		public function getCurrentPlayer():Player{
			return currentPlayer;
		}
		public function getHighestBid():Number{
			return highestBid;
		}
		private function resetAuctionTimer():void{
			auctionTimeLeft = Config.auctionLength / 1000;
			dispatchEvent(new GameEvent(GameEvent.AuctionTimerUpdate,{'timeLeft':auctionTimeLeft}));
			clearTimeout(auctionTimer);
			clearInterval(auctionTimerInterval);
			
			auctionTimer = setTimeout(function():void{
				checkHighestBid();
			},Config.auctionLength);
			auctionTimerInterval = setInterval(function():void{
				auctionTimeLeft -= 1;
				dispatchEvent(new GameEvent(GameEvent.AuctionTimerUpdate,{'timeLeft':auctionTimeLeft}));
				trace('you have '+auctionTimeLeft+' seconds remaining to make an offer');
			},1000);
		}
		private function stopAuctionTimer():void {
			clearTimeout(auctionTimer);
			clearInterval(auctionTimerInterval);
			auctionTimeLeft = -1;
		}
		private function checkHighestBid():void {
			stopAuctionTimer();
			trace('THATS IT! NO MORE BIDDING');
			trace('Highestbid: '+ highestBid+' by '+highestBidHolder.getName());
			currentPlayer.requestBuyOption(highestBid, highestBidHolder);
		}
		
		public function auctionerBuysAnimal():void{
			
			trace('I WANT IT MY SELF!!');
			//buy animal
			currentPlayer.animalCards.push(auctionedAnimal);
			
			if(highestBid > 0){
			//money transfer
			dispatchEvent(new GameEvent(GameEvent.MoneyUpdated,{}));
			currentPlayer.transferMoney(highestBidHolder,highestBid);
			}
			
			highestBidHolder = currentPlayer;
			
			auctionEnded();
			//end turn			
			nextPlayer();
		}
		public function getHighestBidder():Player{
			return highestBidHolder;
		}
		public function auctionerSellsAnimal():void{
			//sell animal
			highestBidHolder.animalCards.push(auctionedAnimal);
			
			
			
			//money transfer
			dispatchEvent(new GameEvent(GameEvent.MoneyUpdated,{}));
			highestBidHolder.transferMoney(currentPlayer,highestBid);
			
			auctionEnded();
			//end turn			
			nextPlayer();
		}
		public function getPlayers():Array{
			return players;
		}
		public function auctionEnded():void{
			notifyPlayersAuctionEnded();
			dispatchEvent(new GameEvent(GameEvent.AnimalSold,{'player':highestBidHolder,'animal':auctionedAnimal}));
			auctionedAnimal = null;
			highestBid = 0;
			highestBidHolder = null;
		}
		public function notifyPlayersAuctionEnded():void{
			//acution ready
			
			for(var i:int in players){
				if(players[i] != currentPlayer){
					(players[i] as Player).auctionOver();
				}
			}	
		}
		
		public function nextPlayer():void{	
			
			var indexNewPlayer:int = players.indexOf(currentPlayer);
			if(indexNewPlayer == players.length-1){
				indexNewPlayer = 0;
			}else{
				indexNewPlayer++;
			}
			currentPlayer = players[indexNewPlayer];
			newTurn();
		}
		
		public function makeOffer(callingPlayer:Player, offer:Number):void {
			if(offer > highestBid && highestBidHolder != null){
				trace(highestBidHolder.getName()+' offered: '+offer +' highest bid == ' +highestBid);
				resetAuctionTimer();
				highestBid = offer;
				highestBidHolder = callingPlayer;
				notifyPlayersOfAuction();
				dispatchEvent(new GameEvent(GameEvent.AuctionOffer,{'offer':highestBid, 'player':highestBidHolder}));
			}			
		}
		public function skipTurn(ownerPlayer:Player):void{
			trace("player skips turn");
			trace('No more animal cards left');
			trace('Scores: ');
			
			for(var i:int in players){
				trace((players[i] as Player).getName()+' has: '+(players[i] as Player).countMoney());
			}
			nextPlayer();
		}
		public function offerTrade(fromPlayer:Player, toPlayer:Player, animal:AnimalCard, offer:Number, realOffer:Array, doubleTrade:Boolean):void{
			trace(fromPlayer.getName() + " wants " + animal.getAnimalName() + " from " + toPlayer.getName());
			currentPlayerOffer = realOffer;
			toPlayer.requestCounterTrade(fromPlayer, animal, offer, doubleTrade);
			
		}
		public function takeOfferedTrade(accepter:Player, animal:AnimalCard, doubleTrade):void{
			//transfer money to the person who received the trade
			currentPlayer.transferMoneyCards(accepter,currentPlayerOffer);
			
			//transfer animals to the person who created trade (currentPlayer)
			var receivedAnimal:AnimalCard = accepter.getAnimalByName(animal.getAnimalName());
			trace(receivedAnimal);
			currentPlayer.animalCards.push(receivedAnimal);
			trace(currentPlayer.getName() + ' gets ' + animal.getAnimalName());

			if(doubleTrade){
				currentPlayer.animalCards.push(accepter.getAnimalByName(animal.getAnimalName()));
				trace(currentPlayer.getName() + ' gets ' + animal.getAnimalName());
			}
			
			dispatchEvent(new GameEvent(GameEvent.AnimalTraded,{'player':accepter,'animal':animal}));
			
			//continue game
			nextPlayer();
		}
		public function makeCounterOffer(tradedPlayer:Player, animal:AnimalCard, doubleTrade:Boolean, counterOffer:Array):void{
			
			trace('Trading player offers:'+CardManager.getTotalForMoneyCards(currentPlayerOffer));
			trace('Traded player offers:'+CardManager.getTotalForMoneyCards(counterOffer));
			
			var animalTradedEvent:GameEvent = null;
			
			if(CardManager.getTotalForMoneyCards(counterOffer) > CardManager.getTotalForMoneyCards(currentPlayerOffer)){
				// counter offer is higher
				tradedPlayer.animalCards.push(currentPlayer.getAnimalByName(animal.getAnimalName()));
				trace(tradedPlayer.getName() + ' gets ' + animal.getAnimalName());
				
				if(doubleTrade){
					tradedPlayer.animalCards.push(currentPlayer.getAnimalByName(animal.getAnimalName()));
					trace(tradedPlayer.getName() + ' gets ' + animal.getAnimalName());
				}
				
				animalTradedEvent = new GameEvent(GameEvent.AnimalTraded,{'player':tradedPlayer,'animal':animal});
				
			}else{
				// initial offer is higher (or equal)
				currentPlayer.animalCards.push(tradedPlayer.getAnimalByName(animal.getAnimalName()));
				trace(currentPlayer.getName() + ' gets ' + animal.getAnimalName());
				
				if(doubleTrade){
					currentPlayer.animalCards.push(tradedPlayer.getAnimalByName(animal.getAnimalName()));
					trace(currentPlayer.getName() + ' gets ' + animal.getAnimalName());
				}
				
				animalTradedEvent = new GameEvent(GameEvent.AnimalTraded,{'player':currentPlayer,'animal':animal});
			}
			
			//both players exchange money either case
			//transfer money to the person who received the trade
			currentPlayer.transferMoneyCards(tradedPlayer,currentPlayerOffer);
			// transfer money 
			tradedPlayer.transferMoneyCards(currentPlayer,counterOffer);
			
			
			dispatchEvent(animalTradedEvent);
			nextPlayer();
		}
		public function stop():void{
			// remove event listeners for players
			for(var x:int in players){
				var player:Player = players[x];
				player.stop();
			}
			
			//remove interval
			clearTimeout(auctionTimer);
			clearInterval(auctionTimerInterval);
			clearTimeout(turnTimeout);
			clearTimeout(startGameInterval);
		}
	}
}