package events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{	
		public static const DeckPrepared:String = "deckPrepared";
		public static const CardDrawn:String = "cardDrawn";
		public static const AuctionTimerUpdate:String = "auctionTimerUpdate";
		public static const AuctionOffer:String = "auctionOffer";
		public static const NewTurn:String = "newTurn";
		public static const MoneyUpdated:String = "moneyUpdated";
		public static const AnimalSold:String = "animalSold";
		public static const RequestBuyOption:String = "requestBuyOption";
		public static const RequestTurnOption:String = "requestTurnOption";
		public static const RequestTradePartner:String = "requestTradePartner";
		public static const RequestTradeCounterOffer:String = "requestTradeCounterOffer";
		public static const AnimalTraded:String = "animalTraded";



		
		public var values:Object;
		public static var GameEnded:String = "gameEnded";

		public function GameEvent(type:String, values:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.values = values;
			super(type, bubbles, cancelable);
		}
	}
}