package model
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import configuration.Config;

	public class Player
	{
		public var animalCards:Array = [];
		public var moneyCards:Array = [];
		public var totalScore:Number = 0;
		
		private var makeBidTimeout:uint;
		private var name:String;
		private var g:SinglePlayerModel;
		public var tradeCandidates:Array;
		public var animalTradeCandidates:Array;
		public var profileImage:String;
		public var goodTradePartner:Player;
		public function Player(r_name:String, playerImageName:String='farmer3')
		{
			name = r_name;
			g = SinglePlayerModel.currentGame;
			
			profileImage = playerImageName;
		}
		public function requestTurnChoice():void{
			// check if any player that is eligble for trade has a low amount of money cards
			
			if(canTradeAnimal()){
				var potentialTrades:Boolean = false;
				if(g.difficulty == Config.GameDifficulty_NORMAL && this.tradeableCandidatesLowMoneyCards()){
					potentialTrades = true;
				}
				if(g.difficulty == Config.GameDifficulty_HARD && this.tradeableCandidatesLowMoneyAmount()){
					potentialTrades = true;
				}
				
				if(potentialTrades){
					var possibleAnimals:Array = this.getAnimalsForTrade(goodTradePartner);
					var highestValueAnimal:AnimalCard = possibleAnimals[0];
					for(var i:int in possibleAnimals){
						var curAnimal:AnimalCard = possibleAnimals[i];
						if(curAnimal.value > highestValueAnimal.value){
							highestValueAnimal = curAnimal;
						}
					}
					
					var doubleTrade:Boolean = false;
					
					if(CardManager.checkAmountForName(highestValueAnimal.getAnimalName(),this.animalCards) == 2
						&& CardManager.checkAmountForName(highestValueAnimal.getAnimalName(), goodTradePartner.animalCards) == 2){
						// trade for 2 because receiver and offerer both have 2
						doubleTrade = true;
						trace('NOW TRADING FOR DOUBLE ANIMALS');
					}
					
					var realOffer:Array = this.getCardsForAmount(g.gameMoneyAverage*0.3);
					if(doubleTrade){
						realOffer = this.getCardsForAmount(g.gameMoneyAverage*0.45);
					}
					
					// protect overpaying
					var totalOffer:int = CardManager.getTotalForMoneyCards(realOffer);
					if(doubleTrade){
						if(totalOffer > highestValueAnimal.value * 1.5){
							realOffer = this.getCardsForAmount(highestValueAnimal.value * 1.5);
						}
					}else if(totalOffer > highestValueAnimal.value * 0.8){
						realOffer = this.getCardsForAmount(highestValueAnimal.value * 0.8);
					}	
					
					if(g.difficulty == Config.GameDifficulty_NORMAL && tradeableCandidatesLowMoneyCards()){
						g.offerTrade(this, goodTradePartner, curAnimal, realOffer.length, realOffer,doubleTrade);
						
					} else if(g.difficulty == Config.GameDifficulty_HARD && tradeableCandidatesLowMoneyAmount()){
						g.offerTrade(this, goodTradePartner, curAnimal, realOffer.length, realOffer,doubleTrade);
					}
				}else{
					doAuctionTradeOrSkip();
				}
			}
			else{
				doAuctionTradeOrSkip();
			}
		}
		
		private function doAuctionTradeOrSkip():void{
			if(g.getAnimalDeck().length > 0){
				g.auctionAnimal(this);
			}else if(g.getAnimalDeck().length == 0 && canTradeAnimal()){
				// start trade
				determineBestTrade();
			}
			else{
				trace(canTradeAnimal());
				g.skipTurn(this);
			}		
		}
		
		public function tradeableCandidatesLowMoneyCards():Boolean{
			// check if candidates in tradeCandidates have low amount of money cards ( below 4 )
			for(var i:int in tradeCandidates){
				var tradeablePlayer:Player = tradeCandidates[i];
				if(tradeablePlayer.moneyCards.length < 4){
					goodTradePartner = tradeablePlayer;
					return true;
				}
			}
			return false;
		}
		public function tradeableCandidatesLowMoneyAmount():Boolean{
			// check if candidates in tradeCandidates have low amount of money amount ( below 40% of gameAverage )
			for(var i:int in tradeCandidates){
				var tradeablePlayer:Player = tradeCandidates[i];
				if(tradeablePlayer.countMoney() < g.gameMoneyAverage * 0.4){
					goodTradePartner = tradeablePlayer;
					return true;
				}
			}
			return false;
		}
		
		public function determineBestTrade():void
		{
			var highestValue:Number = 0;
			var highestValueAnimal:AnimalCard;
			for(var x:int in animalTradeCandidates){
				if((animalTradeCandidates[x] as AnimalCard).getAnimalValue() > highestValue){
					highestValue = (animalTradeCandidates[x] as AnimalCard).getAnimalValue();
					highestValueAnimal = animalTradeCandidates[x];
				}
			}
			var offerCount:int = 0;
			var tradePartner:Player = getTradePartnerWithLeastAnimalCards(highestValueAnimal.getAnimalName(),getPersonsForTrade(highestValueAnimal));
			var realOffer:Array;
			var doubleTrade:Boolean = false;
				
			//loop through animals of offerer
			var animalList:String = "";
			for(var z:int in animalCards){
				animalList += (animalCards[z] as AnimalCard).getAnimalName() + ' , ';
			}
			trace('offerer has: '+animalList);
			
			animalList = "";
			//loop through animals of tradePartner
			for(var u:int in tradePartner.animalCards){
				animalList += (tradePartner.animalCards[u] as AnimalCard).getAnimalName() + ' , ';
			}
			trace('tradePartner has: '+ animalList);
			
			if(CardManager.checkAmountForName(highestValueAnimal.getAnimalName(),this.animalCards) == 2
			&& CardManager.checkAmountForName(highestValueAnimal.getAnimalName(), tradePartner.animalCards) == 2){
				// trade for 2 because receiver and offerer both have 2
				doubleTrade = true;
				trace('NOW TRADING FOR DOUBLE ANIMALS');
				
			}
			
			//determine offer
			if(countMoney() >= highestValueAnimal.getAnimalValue() * 0.8 && !doubleTrade){
				realOffer = getCardsForAmount(highestValueAnimal.getAnimalValue() * 0.8);
			}else if(countMoney() >= highestValueAnimal.getAnimalValue() * 1.5 && doubleTrade){
				realOffer = getCardsForAmount(highestValueAnimal.getAnimalValue() * 1.8);
			}
			else if(countMoney() > 0){
				realOffer = getCardsForAmount(countMoney());
			}else{
				realOffer = [];
			}
			offerCount = realOffer.length;
			if(offerCount == 0 && tradePartner.moneyCards.length == 0 || offerCount > 0){
				g.offerTrade(this, tradePartner,highestValueAnimal,offerCount, realOffer, doubleTrade);
			}else{
				g.skipTurn(this);
			}
		}
		
		private function getTradePartnerWithLeastAnimalCards(animalName:String, players:Array):Player
		{
			var lowestAnimalCount:Number = 4;
			var lowestAnimalCountPlayer:Player;
			
			for(var x:int in players){
				var currentPlayer:Player = players[x];
				var animalCount:Number = CardManager.checkAnimalAmountForName(animalName, currentPlayer.animalCards);
				if(animalCount < lowestAnimalCount){
					lowestAnimalCount = animalCount
					lowestAnimalCountPlayer = currentPlayer;
				}
			}

			return lowestAnimalCountPlayer;
		}
		
		public function requestCounterTrade(fromPlayer:Player, animal:AnimalCard, offer:Number, doubleTrade:Boolean):void{
			
			//determine what to do
			var animalCount:Number = CardManager.checkAnimalAmountForName(animal.name, animalCards);
			var amountOfDifferentAnimals:Number = CardManager.checkAmountOfDifferentAnimals(animalCards);
			
			//if decent offer and only have one of this animal and you have more than 4 animals
			if(offer > 3 && amountOfDifferentAnimals > 4 && animal.value < 500 && animalCount == 1){
				//take offer dont countertrade
				g.takeOfferedTrade(this, animal, doubleTrade);
			}else if(moneyCards.length == 0){
				g.takeOfferedTrade(this, animal, doubleTrade);
			}else{
			
				//dont take offer, make counteroffer
				var counterOfferAmount:Number = animal.value * 0.8;
				
				if(doubleTrade){
					counterOfferAmount = animal.value * 1.6;
				}
				
				if(counterOfferAmount > countMoney()){
					counterOfferAmount = countMoney();
				}
				
				var counterOffer:Array = getCardsForAmount(counterOfferAmount);
				g.makeCounterOffer(this, animal, doubleTrade, counterOffer);
			}
			
			
		}
		
		public function getAnimalByName(animalName:String):AnimalCard {
			var animalCardIndex:int = 0;
			for(var x:int in animalCards){
				if((animalCards[x] as AnimalCard).getAnimalName() == animalName){
					animalCardIndex = x;
					break;
				}
			}
			var animalCard:AnimalCard = animalCards.splice(animalCardIndex,1)[0];
			return animalCard;	
		}
		
		public function canTradeAnimal():Boolean
		{
			tradeCandidates = [];
			animalTradeCandidates = [];

			for(var x:int in animalCards){
				var playerArray:Array = g.getPlayers();
				for(var i:int in playerArray){
					if(playerArray[i] != this){
						var playerAnimalCards:Array = (playerArray[i] as Player).animalCards;
					
						for(var y:int in playerAnimalCards){
							if((playerAnimalCards[y] as AnimalCard).getAnimalName() == (animalCards[x] as AnimalCard).getAnimalName()){
								if(tradeCandidates.indexOf(playerArray[i]) == -1){
									tradeCandidates.push(playerArray[i]);
								}
								if(animalTradeCandidates.indexOf(animalCards[x]) == -1){
									animalTradeCandidates.push(animalCards[x]);
								}
							}
						}
					}
				}				
			}
			if(tradeCandidates.length == 0){
				return false;
			}
			return true;
		}
		
		public function getPersonsForTrade(animalCard:AnimalCard):Array{
			var possiblePlayers:Array = [];
			var playerArray:Array = g.getPlayers();
			for(var i:int in playerArray){
				if(playerArray[i] != this){
					var playerAnimalCards:Array = (playerArray[i] as Player).animalCards;
					
					for(var y:int in playerAnimalCards){
						if((playerAnimalCards[y] as AnimalCard).getAnimalName() == animalCard.getAnimalName()){
							if(possiblePlayers.indexOf(playerArray[i]) == -1){
								possiblePlayers.push(playerArray[i]);
							}
							
						}
					}
				}
			}				
			return possiblePlayers;
		}
		public function getAnimalsForTrade(playerToTrade:Player):Array{
			var animals:Array = [];
			
			for(var i:int in this.animalCards){
				// check for every animalcard if playerToTrade has it
				var myAnimalCard:AnimalCard = this.animalCards[i];
				for(var x:int in playerToTrade.animalCards){
					var hisAnimalCard:AnimalCard = playerToTrade.animalCards[x];
					if(hisAnimalCard.name == myAnimalCard.name && animals.indexOf(myAnimalCard) == -1){
						animals.push(myAnimalCard);
						break;
					}
				}
			}
			return animals;
		}
		public function requestAuctionBid():void{
			clearTimeout(makeBidTimeout);
						makeBidTimeout = setTimeout(function():void{
							makeOffer();
						},Math.random()*Config.auctionLength * 0.2);
//			makeOffer();
		}
		public function auctionOver():void{
			clearTimeout(makeBidTimeout);
		}
		public function requestBuyOption(highestBid:Number, highestBidHolder:Player):void{
			if(highestBid > countMoney()){
				g.auctionerSellsAnimal();
			}else if(g.getAuctionedAnimal().getAnimalValue() * 0.7 > highestBid && highestBid <= countMoney()){
				g.auctionerBuysAnimal();
			}else if (highestBid < 50 && g.difficulty == Config.GameDifficulty_HARD && countMoney() >= 100){
				g.auctionerBuysAnimal();
			}else{
				
				//TODO
				g.auctionerSellsAnimal();
			}
		}
		public function transferMoney(targetPlayer:Player,highestBid:Number):void{
			var moneyToGive:Array = getCardsForAmount(highestBid);			
			for(var i:int in moneyToGive){
				var index:int = moneyCards.indexOf(moneyToGive[i]);
				moneyCards.splice(index,1);
				targetPlayer.moneyCards.push(moneyToGive[i]);
			}
		}
		public function transferMoneyCards(targetPlayer:Player,payableCards:Array):void{
			trace('****Money transfer starts');
			for(var i:int in payableCards){
				var moneyCard:MoneyCard = payableCards[i];
				var index:int = CardManager.getIndexOfMoneyCardForValue(moneyCard.getValue,moneyCards);
				var theCard:MoneyCard = moneyCards.splice(index,1)[0];
				trace("Card: "+theCard.getValue+" at index "+index);
				targetPlayer.moneyCards.push(theCard);
			}
		}
		
		private function getCardsForAmount(amount:Number):Array{
			var bestCards:Array = [];
			//get most valuable payment
			var sortedMoneyCards:Array = moneyCards.sort(sortCardsDescending);
			
			var bestTotal:Number = 999999;
			var currentTotal:Number = 0;
			var currentArray:Array = [];
			var skipIndexes:Array = [];
			for(var x:int = 0; x < 10; x++){
				for(var i:int in sortedMoneyCards){
					if(skipIndexes.indexOf(i) == -1){
						currentTotal += (sortedMoneyCards[i] as MoneyCard).getValue;
						currentArray.push(sortedMoneyCards[i]);
						if(currentTotal == amount){
							// if it matches perfectly, continue
							bestCards = currentArray;
							bestTotal = currentTotal;
							break;
						}else if(currentTotal > amount && currentTotal <= bestTotal){
							// if it's bigger than the amount you need to save it, continue to find a better index
							bestCards = currentArray;
							bestTotal = currentTotal;
							//reset current for next round
							currentTotal = 0;
							currentArray = [];
							skipIndexes.push(i);
							break;
						}
						
					}
				}
				//reset currents for next rounds
				currentTotal = 0;
				currentArray = [];
				if(currentTotal == amount){
					break;
				}
			}
//			trace('**DEBUG');
//			trace(amount);
//			trace(bestTotal);
//			trace('**DEBUG');
			
			return bestCards;
		}
		public function getName():String{
			return name;
		}
		private function makeOffer():void{
			var offerAmount:Number = g.getHighestBid() + 10;
			var valueAuctionedAnimal:Number = g.getAuctionedAnimal().getAnimalValue();
			var animalValueLimit:Number = g.getAuctionedAnimal().getAnimalValue();
			
			if(valueAuctionedAnimal > 499){
				offerAmount = g.getHighestBid() + 20;
			}
			
			//start expensive animals @ 50
			if(valueAuctionedAnimal > 100 && countMoney() >= 50 && g.getHighestBid() < 50){
				trace('start of auction little higher');
				offerAmount = 50;
			}
			
			//if already have animal be willing to go higher
			if(valueAuctionedAnimal < 500 && CardManager.checkAnimalAmountForValue(valueAuctionedAnimal,animalCards) > 0){
				trace('animalValue limit raised, I already have this');
				animalValueLimit = animalValueLimit * 2;
			}
			if(CardManager.checkAnimalAmountForValue(valueAuctionedAnimal,animalCards) == 0 && CardManager.checkAmountOfDifferentAnimals(animalCards) < 4){
				animalValueLimit = valueAuctionedAnimal * ((g.donkeyCount+1) / 3);
				if(animalValueLimit > 800){
					animalValueLimit = 800;
				}
				if(valueAuctionedAnimal == 10){
					animalValueLimit = 40 + g.donkeyCount * 40;
				}
			}
			
			if(offerAmount <= countMoney() && g.getHighestBidder() != this && offerAmount <= animalValueLimit){
				g.makeOffer(this,offerAmount);
			}
		}
		public function countMoney():Number{
			var amount:Number = 0;
			for(var i:int in moneyCards){
				amount += (moneyCards[i] as MoneyCard).getValue;	
			}
			return amount;
		}
		
		private function sortCardsDescending(a:*, b:*):Number
		{
			if((a as MoneyCard).getValue > (b as MoneyCard).getValue) return -1;
			if((a as MoneyCard).getValue == (b as MoneyCard).getValue) return 0;
			else return 1;
		}
		
		public function stop():void
		{
			clearTimeout(makeBidTimeout);
		}
	}
}