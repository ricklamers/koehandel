package model
{
	public class CardManager
	{
		public const animalNames:Array = ["cat","chicken","cow","dog","donkey","duck","goat","horse","pig","sheep"];
		public const animalPrefixes:Array = ["de", "de", "de", "de", "de", "de", "de", "het", "het", "het"];
		public const animalNamesTranslations:Array = [["kat"],["kip"],["koe"],["hond"],["ezel"],["gans"],["geit"],["paard"],["varken"],["schaap"]];
		public const animalValues:Array = [90,10,800,160,500,40,350,1000,650,250];
		
		public function CardManager()
		{
			//empty construct
		}
		public function getStartingMoneyCards():Array{
			var startingCards:Array = [];
			
			// two 0, four 10, one 50
			startingCards.push(new MoneyCard(0));
			startingCards.push(new MoneyCard(0));
			
			startingCards.push(new MoneyCard(10));
			startingCards.push(new MoneyCard(10));
			startingCards.push(new MoneyCard(10));
			startingCards.push(new MoneyCard(10));
			
			startingCards.push(new MoneyCard(50));			
			
			return startingCards;
		}
		
		public function getAnimalDeck():Array{
			var animalDeck:Array = [];
			for(var index:int in animalNames){
				for(var x:int = 0;x<4;x++){
					animalDeck.push(new AnimalCard(animalNames[index],animalValues[index], animalNamesTranslations[index], animalPrefixes[index]));
				}
			}
			
			animalDeck.sort(randomSort);			
			
			return animalDeck;
		}
		private function randomSort(a:*, b:*):Number
		{
			if (Math.random() < 0.5) return -1;
			else return 1;
		}
		public static function haveAnimalWithValue(value:Number, animalCards:Array):Boolean{
			for(var x:int in animalCards){
				var animalCard:AnimalCard = animalCards[x];
				if(animalCard.value == value){
					return true;
				}
			}
			return false;
		}
		public static function checkAmountForName(name:String, cards:Array):Number{
			var amount:int = 0;
			for(var i:int in cards){
				if((cards[i] as AnimalCard).getAnimalName() == name){
					amount ++;
				}
			}	
			return amount;
		}
		
		public static function checkAmountForValue(value:Number,moneyCards:Array):Number{
			var amount:int = 0;
			for(var i:int in moneyCards){
				if((moneyCards[i] as MoneyCard).getValue == value){
					amount ++;
				}
			}	
			return amount;
		}
		public static function checkAnimalAmountForValue(value:Number,animalCards:Array):Number{
			var amount:int = 0;
			for(var i:int in animalCards){
				if((animalCards[i] as AnimalCard).value == value){
					amount ++;
				}
			}	
			return amount;
		}
		public static function getIndexOfMoneyCardForValue(value:Number, moneyCards:Array):int{
			for(var x:int in moneyCards){
				var moneyCard:MoneyCard = moneyCards[x];
				if(moneyCard.getValue == value){
					return x;
				}
			}
			return -1;
		}
		public static function checkAmountOfDifferentAnimals(animalArray:Array):int
		{
			var count:int = 0;
			var countedAnimalsArray:Array = [];
			for(var x:int in animalArray){
				if(countedAnimalsArray.indexOf((animalArray[x] as AnimalCard).name) == -1){
					countedAnimalsArray.push((animalArray[x] as AnimalCard).name);
					count ++;
				}
			}
			return count;
		}
		public static function checkAmountOfDifferentMoneyCards(moneyCards:Array):int{
			var count:int = 0;
			var countedMoneyValues:Array = [];
			for(var x:int in moneyCards){
				if(countedMoneyValues.indexOf((moneyCards[x] as MoneyCard).getValue) == -1){
					countedMoneyValues.push((moneyCards[x] as MoneyCard).getValue);
					count ++;
				}
			}
			return count;
		}
		
		public static function getAnimalByName(animalName:String, animalCards:Array):AnimalCard
		{
			for(var x:int in animalCards){
				var animal:AnimalCard = animalCards[x];
				if(animal.getAnimalName() == animalName){
					return animal;
				}
			}
			return null;
		}
		
		public static function getMoneyCardByName(moneyCardValue:String, moneyCards:Array):MoneyCard
		{
			for(var x:int in moneyCards){
				var moneyCard:MoneyCard = moneyCards[x];
				if(moneyCard.getValue == Number(moneyCardValue)){
					return moneyCard;
				}
			}
			return null;
		}
		
		public static function getTotalForMoneyCards(moneyCards:Array):Number
		{
			var amount:Number = 0;
			for(var i:int in moneyCards){
				amount += (moneyCards[i] as MoneyCard).getValue;	
			}
			return amount;
		}
		

		public static function checkAnimalAmountForName(name:String,animalCards:Array):Number{
			var amount:int = 0;
			for(var i:int in animalCards){
				if((animalCards[i] as AnimalCard).name == name){
					amount ++;
				}
			}	
			return amount;
		}
		
		public static function doubleTradePossible(animalName:String, animalCards:Array, animalCards2:Array):Boolean
		{
			var amountPlayer1:int;
			for(var x:int in animalCards){
				var animalCard:AnimalCard = animalCards[x];
				if(animalCard.name == animalName){
					amountPlayer1 ++;
				}
			}
			var amountPlayer2:int;
			for(var y:int in animalCards2){
				var animalCard2:AnimalCard = animalCards2[y];
				if(animalCard2.name == animalName){
					amountPlayer2 ++;
				}
			}
			trace('here is all good');
			
			if(amountPlayer1 == 2 && amountPlayer2 == 2){
				return true;
			}
			return false;
		}
	}
}