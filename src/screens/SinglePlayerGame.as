package screens
{
	
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import components.BadgeImage;
	import components.DefaultButton;
	import components.DisplayAnimalCard;
	import components.DisplayMoneyCard;
	import components.DonkeyBackground;
	import components.MainPlayerArea;
	import components.Notification;
	import components.PlayerArea;
	import components.PlayerMoneyDeck;
	
	import configuration.Config;
	
	import events.GameEvent;
	
	import interfaces.GameScreen;
	
	import managers.Assets;
	import managers.SoundPlayer;
	
	import model.AnimalCard;
	import model.CardManager;
	import model.MoneyCard;
	import model.Player;
	import model.SinglePlayerModel;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	
	public class SinglePlayerGame extends GameScreen
	{

		private var difficulty:int;

		private var game:Game;

		private var deckCard:DisplayAnimalCard;

		private var auctionCard:DisplayAnimalCard;

		private var auctionTime:TextField;

		private var auctionHighestBid:TextField;

		private var gameModel:SinglePlayerModel;

		private var logicalPlayerArray:Array;

		private var player1:PlayerArea;
		private var player2:PlayerArea;
		private var player3:PlayerArea;

		private var localPlayerAreas:Array;
		private var playerDecks:Array;
		private var currentPlayerLocalIndex:int = 0;

		private var offerAmount:int = 10;

		private var makeOfferButton:DefaultButton;

		private var makeOfferSubtext:TextField;

		private var moneyDisplay:TextField;

		private var mainPlayerArea:MainPlayerArea;


		private var tempDragDropMoneyPosition:Point;

		private var dropCard:DisplayMoneyCard;

		private var tempHiddenCard:DisplayMoneyCard;

		private var tempPickedUpMoneyCard:DisplayMoneyCard;

		private var tradeProcess_chosenPlayer:Player;

		private var tradeProcess_offerAnimal:AnimalCard;

		private var tradeProcess_chosenMoneyCards:Array;

		private var submitOfferButton:DefaultButton;

		private var tradeProcess_animalCandidates:Array;

		private var tradeProcess_playerCandidates:Array;

		private var tradeProcess_selectedAnimals:Array;

		public var tradeProcess_active:Boolean;

		private var tempPickedUpMoneyCards:Array;

		private var acceptTradeOfferButton:DefaultButton;

		private var makeCounterTradeOfferButton:DefaultButton;

		private var submitCounterOfferButton:DefaultButton;

		private var gameSong:Sound;

		private var soundPlayer:SoundPlayer;

		private var gameSongChannel:SoundChannel;

		private var notification:Notification;

		private var donkeyBackdrop:DonkeyBackground;

		private var deckCounter:TextField;

		private var moneySelectionHasStartedTouching:Boolean;

		private var playerBadges:Sprite;

		private var showPlayerBadgesTimeout:int;
		
		public function SinglePlayerGame(p_difficulty:int)
		{
			game = Game.getGame();
			difficulty = p_difficulty;
			// init config based on diff
			
			// set length of game, Hard is 7 sec, Normal 8 sec, and Easy 10 sec.
			if(difficulty == Config.GameDifficulty_NORMAL){
				Config.auctionLength = 9000;
			}else{
				Config.auctionLength = 6000;
			}

			
			// init song
			gameSong = new Assets.SoundGameSong();
			
			gameSongChannel = gameSong.play(0,9999, new SoundTransform(0.4));
			
			// init background
			var backgroundImage:Image = new Image(game.assets.mainBG);
			backgroundImage.height = backgroundImage.height / (backgroundImage.width / game.stageWidth);
			backgroundImage.width = game.stageWidth;		
			addChild(backgroundImage);
			
			// init menu button
			var menuButton:DefaultButton = new DefaultButton(game.stageWidth * 0.08, game.stageWidth * 0.05,"MENU",12,Config.redColor);
			
			menuButton.y = menuButton.height * 0.8;
			menuButton.x = game.stageWidth - menuButton.width * 0.8;
			menuButton.addEventListener(TouchEvent.TOUCH, menuButtonListener);
			
			//init display holder for players
			
			localPlayerAreas = [];
			playerDecks = [];
			
			// init auction elements
			auctionTime = new TextField(game.stageWidth * 0.05, game.stageWidth * 0.05, Config.auctionLength/1000+"", Config.fontName, 18*Config.fontScaling, 0xffffff);
			auctionTime.x = game.stageWidth - auctionTime.width * 1.5;
			auctionTime.y = game.stageHeight - auctionTime.height * 1.5;
			auctionTime.visible = false;
			addChild(auctionTime);
			
			auctionHighestBid = new TextField(game.stageWidth * 0.5, game.stageWidth * 0.15, "Hoogste bod: 0", Config.fontStrokedName, 16*Config.fontScaling, 0xffffff);
			auctionHighestBid.x = game.stageWidth / 2 - auctionHighestBid.width /2;
			auctionHighestBid.y = game.stageHeight * 0.57;
			auctionHighestBid.visible = false;
			addChild(auctionHighestBid);			
			
			//init soundplayer
			soundPlayer = new SoundPlayer();
			
			// init card 
			gameModel = new SinglePlayerModel(difficulty);
			
			gameModel.addEventListener(GameEvent.DeckPrepared, deckIsPrepared);
			gameModel.addEventListener(GameEvent.CardDrawn, cardDrawn);
			gameModel.addEventListener(GameEvent.AuctionTimerUpdate, updateAuctionTimer);
			gameModel.addEventListener(GameEvent.AuctionOffer, auctionOfferUpdate);
			gameModel.addEventListener(GameEvent.NewTurn, newTurn);
			gameModel.addEventListener(GameEvent.MoneyUpdated, moneyUpdated);
			gameModel.addEventListener(GameEvent.AnimalSold, animalSold);
			gameModel.addEventListener(GameEvent.RequestBuyOption, requestBuyOption);
			gameModel.addEventListener(GameEvent.RequestTurnOption, requestTurnOption);
			gameModel.addEventListener(GameEvent.RequestTradePartner, findTradePartner);
			gameModel.addEventListener(GameEvent.RequestTradeCounterOffer, showCounterTradeOptions);
			gameModel.addEventListener(GameEvent.AnimalTraded, animalTraded);
			gameModel.addEventListener(GameEvent.GameEnded, gameEnded);


			// init notification
			notification = new Notification();
			notification.x = (game.stageWidth - notification.width) /2;
			
			// init player UI
			// init bid buttons
			
			mainPlayerArea = new MainPlayerArea();
			
			//position mainPlayerArea
			mainPlayerArea.y = game.stageHeight - game.stageHeight * Config.mainPlayerAreaHeight;
			
			makeOfferButton = new DefaultButton(game.stageWidth * 0.16, game.stageHeight * 0.12, "Bied "+(gameModel.getHighestBid()+10),13*Config.fontScaling,Config.redColor,false);
			makeOfferSubtext = new TextField(makeOfferButton.width, makeOfferButton.height /2, "(+"+offerAmount+")",Config.fontName,10*Config.fontScaling,0xffffff);
			makeOfferSubtext.y = makeOfferButton.height/2.5;
			makeOfferSubtext.visible = false;
			makeOfferButton.addChild(makeOfferSubtext);
			makeOfferButton.x = (game.stageWidth * 0.5);
			makeOfferButton.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + makeOfferButton.height /2 ;
			makeOfferButton.addEventListener(TouchEvent.TOUCH, makeOffer);
			mainPlayerArea.mainPlayerBidArea.addChild(makeOfferButton);
			
			var increaseOfferButton:DefaultButton = new DefaultButton(game.stageHeight * 0.12, game.stageHeight*0.12,"+",25,Config.redColor);
			increaseOfferButton.x = (game.stageWidth * 0.5) + increaseOfferButton.width * 1.8;
			increaseOfferButton.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + makeOfferButton.height /2;
			increaseOfferButton.addEventListener(TouchEvent.TOUCH, increaseOffer);
			mainPlayerArea.mainPlayerBidArea.addChild(increaseOfferButton);
			
			var decreaseOfferButton:DefaultButton = new DefaultButton(game.stageHeight * 0.12, game.stageHeight*0.12,"-",25,Config.redColor);
			decreaseOfferButton.x = (game.stageWidth * 0.5) - decreaseOfferButton.width * 1.8;
			decreaseOfferButton.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + makeOfferButton.height /2;
			decreaseOfferButton.addEventListener(TouchEvent.TOUCH, decreaseOffer);
			mainPlayerArea.mainPlayerBidArea.addChild(decreaseOfferButton);
			
			submitOfferButton = new DefaultButton(game.stageWidth * 0.12, game.stageWidth * 0.06, "Klaar!",13,Config.redColor);
			submitOfferButton.x = game.stageWidth/2 + submitOfferButton.width * 0.6;
			submitOfferButton.y = game.stageHeight/2;
			submitOfferButton.visible = false;
			submitOfferButton.addEventListener(TouchEvent.TOUCH, submitTrade);
			addChild(submitOfferButton);
			
			submitCounterOfferButton = new DefaultButton(game.stageWidth * 0.18, game.stageWidth * 0.06, "Tegenbod!",12,Config.redColor);
			submitCounterOfferButton.x = game.stageWidth/2 + submitCounterOfferButton.width * 0.6;
			submitCounterOfferButton.y = game.stageHeight/2;
			submitCounterOfferButton.visible = false;
			submitCounterOfferButton.addEventListener(TouchEvent.TOUCH, submitCounterOffer);
			addChild(submitCounterOfferButton);
			
			
			acceptTradeOfferButton = new DefaultButton(game.stageWidth * 0.14, game.stageWidth * 0.06, "Accepteer",12,Config.redColor);
			acceptTradeOfferButton.x = game.stageWidth/2 + acceptTradeOfferButton.width * 0.7;
			acceptTradeOfferButton.y = game.stageHeight/2;
			acceptTradeOfferButton.visible = false;
			acceptTradeOfferButton.addEventListener(TouchEvent.TOUCH, acceptTrade);
			addChild(acceptTradeOfferButton);
			
			makeCounterTradeOfferButton = new DefaultButton(game.stageWidth * 0.14, game.stageWidth * 0.06, "Tegenbod",12,Config.redColor);
			makeCounterTradeOfferButton.x = game.stageWidth/2 + acceptTradeOfferButton.width * 0.7;
			makeCounterTradeOfferButton.y = game.stageHeight/2 + acceptTradeOfferButton.height;
			makeCounterTradeOfferButton.visible = false;
			makeCounterTradeOfferButton.addEventListener(TouchEvent.TOUCH, makeCounterTradeInit);
			addChild(makeCounterTradeOfferButton);
			
			dropCard = new DisplayMoneyCard('drop_card');
			dropCard.scaleX = dropCard.scaleY = dropCard.scaleY*1.05;
			dropCard.x = game.stageWidth /2 - dropCard.width * 1.8;
			dropCard.y = game.stageHeight /2;
			dropCard.visible = false;
			addChild(dropCard);
			
			// init turn option buttons
			var chooseAuctionOption:DefaultButton = new DefaultButton(game.stageWidth * 0.16, game.stageWidth * 0.08, "Veilen",12,Config.redColor);
			chooseAuctionOption.x = game.stageWidth / 2 + chooseAuctionOption.width * 0.6;
			chooseAuctionOption.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + chooseAuctionOption.height /2;
			chooseAuctionOption.addEventListener(TouchEvent.TOUCH, chooseAuctionTurn);

			mainPlayerArea.mainPlayerChoiceArea.addChild(chooseAuctionOption);
			
			var chooseTradeOption:DefaultButton = new DefaultButton(game.stageWidth * 0.16, game.stageWidth * 0.08, "Handelen",12,Config.redColor);
			chooseTradeOption.x = game.stageWidth / 2 - chooseTradeOption.width * 0.6;
			chooseTradeOption.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + chooseTradeOption.height /2;
			chooseTradeOption.addEventListener(TouchEvent.TOUCH, chooseTradeTurn);
			mainPlayerArea.mainPlayerChoiceArea.addChild(chooseTradeOption);
			
			// init turn option buttons
			var chooseSellAnimal:DefaultButton = new DefaultButton(game.stageWidth * 0.18, game.stageWidth * 0.08, "Verkoop",12,Config.redColor);
			chooseSellAnimal.x = game.stageWidth / 2 + chooseSellAnimal.width * 0.6;
			chooseSellAnimal.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + chooseSellAnimal.height /2;
			chooseSellAnimal.addEventListener(TouchEvent.TOUCH, sellAnimal);
			mainPlayerArea.mainPlayerSellChoiceArea.addChild(chooseSellAnimal);
			
			var chooseBuyAnimal:DefaultButton = new DefaultButton(game.stageWidth * 0.18, game.stageWidth * 0.08, "Koop zelf!",12,Config.redColor);
			chooseBuyAnimal.x = game.stageWidth / 2 - chooseBuyAnimal.width * 0.6;
			chooseBuyAnimal.y = game.stageHeight * Config.mainPlayerAreaHeight * 0.2 + chooseBuyAnimal.height /2;
			chooseBuyAnimal.addEventListener(TouchEvent.TOUCH, buyAnimal);
			mainPlayerArea.mainPlayerSellChoiceArea.addChild(chooseBuyAnimal);
			
			// init show animals button
			var showAnimalsButton:DisplayAnimalCard = new DisplayAnimalCard('animal_back',false);
			showAnimalsButton.width /= 1.6;
			showAnimalsButton.height /= 1.6;
			showAnimalsButton.x = showAnimalsButton.width * 0.2;
			showAnimalsButton.y = game.stageHeight * Config.mainPlayerAreaHeight - showAnimalsButton.width * 0.3 - showAnimalsButton.height;
			showAnimalsButton.addEventListener(TouchEvent.TOUCH, showAnimalsListener);

			mainPlayerArea.addChild(showAnimalsButton);

			var showMoneyButton:DisplayMoneyCard = new DisplayMoneyCard('money_back', false);
			showMoneyButton.width /= 1.6;
			showMoneyButton.height /= 1.6;
			showMoneyButton.x = showMoneyButton.width * 0.2 + showAnimalsButton.width * 1.2;
			showMoneyButton.y = game.stageHeight * Config.mainPlayerAreaHeight - showMoneyButton.width * 0.3 - showMoneyButton.height;
			showMoneyButton.addEventListener(TouchEvent.TOUCH, showMoneyListener);

			mainPlayerArea.addChild(showMoneyButton);
			
			
			
			
			// other play areas
			player1 = new PlayerArea();
			player1.rotation = deg2rad(90);
			player1.y = game.stageHeight/2 - game.stageHeight*0.1;
			player1.x = player1.width/2;
			player1.playerDeckCallback = showPlayerBadgesNormal;
			player1.init();			
			
			player2 = new PlayerArea();
			player2.rotation = deg2rad(180);
			player2.y = player2.height/2;
			player2.x = game.stageWidth /2;
			player2.playerDeckCallback = showPlayerBadgesNormal;
			player2.init();
			
			player3 = new PlayerArea();
			player3.rotation = deg2rad(270);
			player3.y = game.stageHeight/2;
			player3.x = game.stageWidth - player3.width/2;
			player3.playerDeckCallback = showPlayerBadgesNormal;
			player3.init();

			
			localPlayerAreas.push(player1,player2,player3);
			
			addChild(player1);
			addChild(player2);
			addChild(player3);
			
			//main player area is late added, needs to be on top			
			addChild(mainPlayerArea);
			
			playerBadges = new Sprite();
			addChild(playerBadges);
			
			addChild(notification);
			
			// add overlay UI
			addChild(menuButton);
			
			
			gameModel.init();
			
			// show player up first
			
//			setTimeout(function():void{
//				notification.showMessage(gameModel.getCurrentPlayer(),"begint het spel!");
//				highlightPlayer(gameModel.getCurrentPlayer());
//			},Config.auctionLength/2);
			
			// add player badges
			// init p1 badge
			
			
			
			var player1Badge:BadgeImage = new BadgeImage(game.assets.getTextureForName((gameModel.getPlayers()[1] as Player).profileImage));
			// align left stage middle 20% margin
			player1Badge.insideY = (game.stageHeight*0.8 - player1Badge.height)/2;
			player1Badge.insideX = game.stageWidth * 0.05;
			player1Badge.outsideX = -player1Badge.width*1.1;
			player1Badge.outsideY = player1Badge.y;
			
			var player2Badge:BadgeImage = new BadgeImage(game.assets.getTextureForName((gameModel.getPlayers()[2] as Player).profileImage));
			player2Badge.insideY = game.stageHeight * 0.1;
			player2Badge.insideX = (game.stageWidth - player2Badge.width)/2;
			player2Badge.outsideX = player2Badge.x;
			player2Badge.outsideY = -player2Badge.height * 1.1;
			
			
			var player3Badge:BadgeImage = new BadgeImage(game.assets.getTextureForName((gameModel.getPlayers()[3] as Player).profileImage));
			player3Badge.insideY = (game.stageHeight*0.8 - player3Badge.height)/2;
			player3Badge.insideX = game.stageWidth - player3Badge.width - game.stageWidth * 0.05;
			player3Badge.outsideX = game.stageWidth + player3Badge.width*1.1;
			player3Badge.outsideY = player3Badge.y;
			
			
			var player4Badge:BadgeImage = new BadgeImage(game.assets.getTextureForName(gameModel.yourself.profileImage));
			player4Badge.insideY = game.stageHeight - player4Badge.height - game.stageHeight * 0.05;
			player4Badge.insideX = (game.stageWidth - player4Badge.width)/2;
			player4Badge.outsideX = player4Badge.x;
			player4Badge.outsideY = game.stageHeight + player4Badge.height * 1.1;

			playerBadges.addChild(player1Badge);
			playerBadges.addChild(player2Badge);
			playerBadges.addChild(player3Badge);
			playerBadges.addChild(player4Badge);
			
			hidePlayerBadges(0);
			showPlayerBadgesNormal();
			
			
			
		}
		
		protected function gameEnded(event:GameEvent):void
		{
			var game:Game = Game.getGame();
			game.gotoScreen('menu');
			(game.showingScreen as Menu).setMenuView('uitslag',gameModel.getPlayers());
			
			unloadSinglePlayer();
		}
		
		private function showPlayerBadgesNormal():void{
			showPlayerBadges(0.5,Config.auctionLength/3/1000);
		}
		
		private function showPlayerBadges(speed:Number, duration:Number):void{
			for(var x:int = 0; x < playerBadges.numChildren; x++){
				var badge:BadgeImage = playerBadges.getChildAt(x) as BadgeImage;
				TweenLite.to(badge,speed,{x:badge.insideX, y:badge.insideY});
			}
			
			if(showPlayerBadgesTimeout){
				clearTimeout(showPlayerBadgesTimeout);
			}
			
			showPlayerBadgesTimeout = setTimeout(function():void{
				for(var x:int = 0; x < playerBadges.numChildren; x++){
					var badge:BadgeImage = playerBadges.getChildAt(x) as BadgeImage;
					TweenLite.to(badge,speed,{x:badge.outsideX, y:badge.outsideY});
				}
				showPlayerBadgesTimeout = 0;
			},duration*1000);
		}
		private function hidePlayerBadges(speed:Number):void{
			for(var x:int = 0; x < playerBadges.numChildren; x++){
				var badge:BadgeImage = playerBadges.getChildAt(x) as BadgeImage;
				TweenLite.to(badge,speed,{x:badge.outsideX, y:badge.outsideY});
			}
		}
		
		private function menuButtonListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				unloadSinglePlayer();
				game.gotoScreen('menu');
			}
		}
		public function registerLocalPlayers():void{
			//get players and put other players ON DECK
			var players:Array = gameModel.getPlayers();
			
			var firstNextPlayerIndex:int = players.indexOf(gameModel.yourself)+1;
			if(firstNextPlayerIndex == players.length){
				firstNextPlayerIndex = 0;
			}
			var x:int = firstNextPlayerIndex;
			var count:int = 0;
			logicalPlayerArray = [];
			while(count < 3){
				var workingPlayer:Player = players[x];
				logicalPlayerArray.push(workingPlayer);
				count ++;
				x ++;
				if(x == 4){
					x = 0;
				}
			}
			playerDecks.push(player1.playerDeck, player2.playerDeck, player3.playerDeck);
			
		}
		
		private function submitCounterOffer(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				trace('submitcounteroffer');
				gameModel.yourself.makeCounterOffer(tradeProcess_chosenMoneyCards);
				submitCounterOfferButton.visible = false;
				tradeProcess_chosenMoneyCards = null;
				tradeProcess_active = false;
				hideMoneySelection();
			}
		}
		
		private function makeCounterTradeInit(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				enableMoneySelection();
				acceptTradeOfferButton.visible = false;
				makeCounterTradeOfferButton.visible = false;
				submitCounterOfferButton.visible = true;
			}
		}
		
		protected function showCounterTradeOptions(event:GameEvent):void
		{
			var offeringPlayer:Player = event.values['player'] as Player;
			var animal:AnimalCard = (event.values['animal'] as AnimalCard);
			notification.showMessage(offeringPlayer,"wilt ruilen om "+animal.dutchNameWithPrefix);
			notification.showMessage(offeringPlayer,"biedt "+event.values['offer'] + " kaarten");
			
			var localPlayerIndex:int = modelToLocalIndex(offeringPlayer);
			(localPlayerAreas[localPlayerIndex] as PlayerArea).showTradeOffer(event.values['offer']);

			selectAnimalsWithNameFromPlayer(animal.name,offeringPlayer,CardManager.doubleTradePossible(animal.name,gameModel.yourself.animalCards,offeringPlayer.animalCards));
			
			acceptTradeOfferButton.visible = true;
			makeCounterTradeOfferButton.visible = true;
		}
		
		private function acceptTrade(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				gameModel.yourself.acceptTradeOffer();
				acceptTradeOfferButton.visible = false;
				makeCounterTradeOfferButton.visible = false;
			}
		}
		
		protected function findTradePartner(event:GameEvent):void
		{
			trace('Find a trade partner');
			tradeProcess_animalCandidates = event.values['animalCandidates'];
			for(var y:int in tradeProcess_animalCandidates){
				var animal:AnimalCard = tradeProcess_animalCandidates[y];
				trace('Can trade for:'+animal.getAnimalName());
			}
			
			tradeProcess_playerCandidates = event.values['playerCandidates'];
			for(var x:int in tradeProcess_playerCandidates){
				var player:Player = tradeProcess_playerCandidates[x];
				trace('Can trade against:'+player.getName());
				
				//create eventlisteners for animals for this player
				var localPlayerIndex:int = this.modelToLocalIndex(player);
				var selectedPlayerArea:PlayerArea = localPlayerAreas[localPlayerIndex];
				
				var amountOfAnimals:int = selectedPlayerArea.animalArea.numChildren;
				
				for(var z:int = 0; z < amountOfAnimals; z++){
					selectedPlayerArea.animalArea.getChildAt(z).addEventListener(TouchEvent.TOUCH,selectTradeAnimal);
				}
				
			}
			
			enableMoneySelection();
			
		}
		private function hideMoneySelection():void{
			
			
			tradeProcess_active = false;
			
			//remove touchListeners
			var numMoneyAreaChildren:Number = mainPlayerArea.moneyArea.numChildren;
			for(var x:int = 0; x < numMoneyAreaChildren; x++){
				mainPlayerArea.moneyArea.getChildAt(x).removeEventListener(TouchEvent.TOUCH,touchMoney);
			}
			this.removeEventListener(TouchEvent.TOUCH,moneyResetListener);
			
			//hide drop area
			dropCard.alpha = 0.5;
			dropCard.visible = false;
			
			//hide dropped money
			for(var i:int in this.tempPickedUpMoneyCards){
				var card:DisplayMoneyCard = tempPickedUpMoneyCards[i];
				card.visible = false;
			}
			
			tempPickedUpMoneyCards = null;
		}
		private function enableMoneySelection():void
		{
			tradeProcess_active = true;
			if(!mainPlayerArea.moneyShowing){
				tradeProcess_active = false;
				
				//hide animals if visible
				if(mainPlayerArea.animalsShowing){
					this.showAnimals();
				}
				showMoney();
				
				tradeProcess_active = true;
			}
			
			dropCard.visible = true;
			dropCard.alpha = 0.6;
			
			for(var z:int = 0; z < mainPlayerArea.moneyArea.numChildren; z++){
				var child:DisplayObject = mainPlayerArea.moneyArea.getChildAt(z);
				if(child.hasOwnProperty('draggable') && (child as DisplayMoneyCard).draggable){
					child.addEventListener(TouchEvent.TOUCH,touchMoney);
				}
			}
			tradeProcess_chosenMoneyCards = [];
			tempPickedUpMoneyCards = [];
			
			this.addEventListener(TouchEvent.TOUCH,moneyResetListener);
		}
		
		private function touchMoney(event:TouchEvent):void
		{
			//money drop function
			
			var touch:Touch = event.touches[0];
			
			if(touch.phase == TouchPhase.BEGAN){
				//started touching card, allow pick up if temPickedUpMoneyCard equals null or does not equal null but is not visible

				if(tempPickedUpMoneyCard == null || tempPickedUpMoneyCard != null && tempPickedUpMoneyCard.visible == false){

					trace(tempPickedUpMoneyCard);
					
					tempHiddenCard = event.target as DisplayMoneyCard;
					tempPickedUpMoneyCard = new DisplayMoneyCard(tempHiddenCard.getName(),false);
					tempPickedUpMoneyCards.push(tempPickedUpMoneyCard);
					
					addChild(tempPickedUpMoneyCard);
					var touchPoint:Point = touch.getLocation(tempHiddenCard);
			
					var pickupPoint:Point = new Point(touch.globalX-(touchPoint.x/2),touch.globalY-(touchPoint.y/2));
	
					tempPickedUpMoneyCard.x = pickupPoint.x;
					tempPickedUpMoneyCard.y = pickupPoint.y;
					this.addEventListener(TouchEvent.TOUCH,moveMoney);
					tempHiddenCard.visible = false;
					tempDragDropMoneyPosition = new Point(pickupPoint.x,pickupPoint.y);	
				}
				
			}
			
		}
		
		private function moveMoney(event:TouchEvent):void{
			var touch:Touch = event.touches[0];
			
			var dropCardRect:Rectangle;
			
			if(touch.phase == TouchPhase.MOVED){
				dropCardRect = new Rectangle(dropCard.x-dropCard.width/2,dropCard.y-dropCard.height/2,dropCard.width,dropCard.height);
				var deltaMovementY:Number = touch.getPreviousLocation(this).y- touch.getLocation(this).y;
				var deltaMovementX:Number= touch.getPreviousLocation(this).x- touch.getLocation(this).x;
				tempPickedUpMoneyCard.y -= deltaMovementY;
				tempPickedUpMoneyCard.x -= deltaMovementX;
				
				if(dropCardRect.contains(touch.globalX, touch.globalY)){
					dropCard.alpha = 1;
				}else{
					dropCard.alpha = 0.5;
				}
			}
			if(touch.phase == TouchPhase.ENDED){
				dropCardRect = new Rectangle(dropCard.x-dropCard.width/2,dropCard.y-dropCard.height/2,dropCard.width,dropCard.height);
				if(dropCardRect.contains(touch.globalX, touch.globalY)){
					//it's dropped, move card to dropCardRect
					var additionOffset:Point = new Point(6/1,8/1);
					
					tradeProcess_chosenMoneyCards.push(CardManager.getMoneyCardByName(tempPickedUpMoneyCard.getName(),gameModel.yourself.moneyCards));
					
					
					TweenLite.to(tempPickedUpMoneyCard,0.15,{x:dropCardRect.x+additionOffset.x, y: dropCardRect.y+additionOffset.y, onComplete:function():void{
						//tempHiddenCard.visible = true;
						tempPickedUpMoneyCard = null;
					}
					});
					
				}else{
					//its dropped outside, move card back
					TweenLite.to(tempPickedUpMoneyCard,0.15,{x:tempDragDropMoneyPosition.x, y: tempDragDropMoneyPosition.y, onComplete:function():void{
						tempHiddenCard.visible = true;
						tempPickedUpMoneyCard.visible = false;
						tempPickedUpMoneyCard.dispose();
					}
					});
				}
				this.removeEventListener(TouchEvent.TOUCH, moveMoney);			
		
			}
		}
		private function moneyResetListener(event:TouchEvent):void{
			var touch:Touch = event.touches[0];
			var dropCardRect:Rectangle;
			if(touch.phase == TouchPhase.BEGAN){
				dropCardRect = new Rectangle(dropCard.x-dropCard.width/2,dropCard.y-dropCard.height/2,dropCard.width,dropCard.height);
				if(dropCardRect.contains(touch.globalX, touch.globalY)){
					moneySelectionHasStartedTouching = true;
				}
			}
			if(touch.phase == TouchPhase.ENDED){
				dropCardRect = new Rectangle(dropCard.x-dropCard.width/2,dropCard.y-dropCard.height/2,dropCard.width,dropCard.height);
				if(moneySelectionHasStartedTouching && dropCardRect.contains(touch.globalX, touch.globalY)){
					moneySelectionHasStartedTouching = false;
					
					//reset money cards
					
					var numChildren:int = this.mainPlayerArea.moneyArea.numChildren;
					
					//show all money cards again
					for(var x:int = 0; x < numChildren; x++){
						var moneyCard:DisplayMoneyCard = (this.mainPlayerArea.moneyArea.getChildAt(x) as DisplayMoneyCard);
						if(moneyCard){
							moneyCard.visible = true;
						}
					}
					
					//remove all cards in dropArea
					for(var z:int in tempPickedUpMoneyCards){
						var tempMoneyCard:DisplayMoneyCard = tempPickedUpMoneyCards[z];
						tempMoneyCard.visible = false;
						tempMoneyCard.dispose();
					}
					tempPickedUpMoneyCards = [];
					
				}
			}
		}
		
		private function selectTradeAnimal(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				
			}
			if(touch.phase == TouchPhase.ENDED){
			
				var selectedAnimal:DisplayAnimalCard = (event.target as DisplayAnimalCard);
				var animalName:String = selectedAnimal.getName();
				var selectedPlayer:Player = logicalPlayerArray[localPlayerAreas.indexOf((event.target as DisplayAnimalCard).parent.parent)];
				
				var animalPresent:Boolean = false;
				
				//loop through animalCandidates to check if animal is chooseable
				for(var x:int in tradeProcess_animalCandidates){
					var currentAnimal:AnimalCard = tradeProcess_animalCandidates[x];
					if(currentAnimal.name == animalName){
						animalPresent = true;
					}
				}
				
				// if animal is selectable, select it
				if(animalPresent){
					// allow selecting if no animal has been selected, another animal is selected or another player is selected
					if(tradeProcess_offerAnimal == null || tradeProcess_offerAnimal != null && tradeProcess_offerAnimal.name != animalName || tradeProcess_offerAnimal != null && tradeProcess_chosenPlayer != selectedPlayer){
						selectAnimalsWithNameFromPlayer(animalName,selectedPlayer,CardManager.doubleTradePossible(animalName, selectedPlayer.animalCards, gameModel.yourself.animalCards));
						//selectAnimalsWithNameFromPlayer(animalName,selectedPlayer,false);
						tradeProcess_chosenPlayer = selectedPlayer;
						submitOfferButton.visible = true;
						tradeProcess_offerAnimal = CardManager.getAnimalByName(animalName,gameModel.yourself.animalCards);
					}
					
				}
			
			}
		}
		public function selectAnimalsWithNameFromPlayer(animalName:String, fromPlayer:Player, doubleSelect:Boolean = true):void{
			
			if(tradeProcess_selectedAnimals != null){
				//first animate selected animals out
				for(var x:int in tradeProcess_selectedAnimals){
					var animal:DisplayAnimalCard = tradeProcess_selectedAnimals[x];
					TweenLite.to(animal,0.3,{y:animal.y+20});
				}
			}
			//now animate animals in
			
			var animalsToAnimate:Array = [];
			var localPlayerArea:PlayerArea = localPlayerAreas[modelToLocalIndex(fromPlayer)];	
			
			var localPlayerAreaAnimalCount:int = localPlayerArea.animalArea.numChildren;			
			
			for(var y:int = localPlayerAreaAnimalCount-1; y > -1; y--){
				var displayAnimalCard:DisplayAnimalCard = localPlayerArea.animalArea.getChildAt(y) as DisplayAnimalCard;
				if(displayAnimalCard.getName() == animalName){
					animalsToAnimate.push(displayAnimalCard);
					if(!doubleSelect){
						break;
					}else if(animalsToAnimate.length > 1){
						break;
					}
				}
			}
			
			
			tradeProcess_selectedAnimals = [];
			for(var z:int in animalsToAnimate){
				var displayAnimal:DisplayAnimalCard = animalsToAnimate[z];
				TweenLite.to(displayAnimal,0.3,{y:displayAnimal.y-20});
				tradeProcess_selectedAnimals.push(displayAnimal);
			}
			
		}
		private function submitTrade(event:TouchEvent):void{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				trace('Moneycards: '+this.tradeProcess_chosenMoneyCards.length);
				trace('With player: '+this.tradeProcess_chosenPlayer.getName());
				trace('Animal: '+this.tradeProcess_offerAnimal.name);
				
				if(gameModel.yourself.makeTrade(tradeProcess_chosenPlayer,tradeProcess_offerAnimal,tradeProcess_chosenMoneyCards)){
					trace('trade made');
					tradeProcess_chosenMoneyCards = null;
					tradeProcess_chosenPlayer = null;
					tradeProcess_offerAnimal = null;
					
					tradeProcess_animalCandidates = null;
					tradeProcess_playerCandidates = null;
					tradeProcess_selectedAnimals = null;
				
					hideMoneySelection();
					//update animals after trade
					drawAnimalCards();
					
					//hide trade button
					submitOfferButton.visible = false;
				
				}else{
					trace('cant make trade');
				}
			}
		}
		
		private function chooseAuctionTurn(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				gameModel.yourself.chooseAuctionTurn();
				mainPlayerArea.mainPlayerChoiceArea.visible = false;
			}
		}
		
		private function chooseTradeTurn(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				gameModel.yourself.chooseTradeTurn();
				mainPlayerArea.mainPlayerChoiceArea.visible = false;
			}
		}
		
		protected function requestTurnOption(event:GameEvent):void
		{
			mainPlayerArea.mainPlayerChoiceArea.visible = true;
		}
		
		private function buyAnimal(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				gameModel.yourself.buyAuctionAnimal();
				mainPlayerArea.mainPlayerSellChoiceArea.visible = false;
			}
		}
		
		private function sellAnimal(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				gameModel.yourself.sellAuctionAnimal();
				mainPlayerArea.mainPlayerSellChoiceArea.visible = false;
			}
		}
		
		protected function requestBuyOption(event:GameEvent):void
		{
			auctionTime.visible = false;
			mainPlayerArea.mainPlayerSellChoiceArea.visible = true;
		}
		
		private function makeOffer(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				var totalOffer:int = (gameModel.getHighestBid()+offerAmount);
				gameModel.yourself.makeOffer(totalOffer);
			}
		}
		
		private function showMoneyListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				filter.adjustBrightness(-0.2);
				filter.resolution = 2;		
				(event.target as Image).filter = filter;
			}
			
			if(touch.phase == TouchPhase.ENDED){
				(event.target as Image).filter = null;
				
				if(mainPlayerArea.animalsShowing){
					showAnimals();
				}
				showMoney();
			}
		
		}
		private function showMoney():void{
			if(mainPlayerArea.moneyShowing){
				mainPlayerArea.moneyShowing = false;
				TweenLite.to(mainPlayerArea.moneyArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
				//hide money
			}else{
				mainPlayerArea.moneyShowing = true;
				//show money
				if(!tradeProcess_active){
				drawPlayerMoney();
				
				TweenLite.from(mainPlayerArea.moneyArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
				}else{
					//create moneyCard to get size
					var moneyCard:DisplayMoneyCard = new DisplayMoneyCard('0',false);
					TweenLite.to(mainPlayerArea.moneyArea,0.5,{y:((game.stageHeight * Config.mainPlayerAreaHeight) - (moneyCard.height)) /2});	
					
				}
				
			}
		}
		
		private function drawPlayerMoney():void
		{
			if(mainPlayerArea.moneyShowing){
				var sortedMoneyArray:Array = gameModel.yourself.moneyCards;
				sortedMoneyArray.sort(sortMoneyByValue);
				
				//create moneyCard to get size
				var moneyCard:DisplayMoneyCard = new DisplayMoneyCard('0',false);
				
				var previousMoneyCard:Number = -1;
				var moneyCount:int = 0;
				mainPlayerArea.moneyArea.removeChildren();

				mainPlayerArea.moneyArea.y = ((game.stageHeight * Config.mainPlayerAreaHeight) - (moneyCard.height)) /2;
				
				for(var y:int in sortedMoneyArray){
					//draw money
					
					var currentMoneyCard:MoneyCard = (sortedMoneyArray[y] as MoneyCard);
					var thisPlayerCardWidth:Number = moneyCard.width;
					var leftOffset:Number = mainPlayerArea.width * 0.15;
					
					var amountOfMoneyCards:int = CardManager.checkAmountOfDifferentMoneyCards(sortedMoneyArray);
					if(amountOfMoneyCards > 5){
						thisPlayerCardWidth = (mainPlayerArea.width*0.65)/(amountOfMoneyCards+1);
					}
					
					if(currentMoneyCard.getValue != previousMoneyCard){
						
						var currentMoneyCount:Number = CardManager.checkAmountForValue(currentMoneyCard.getValue,gameModel.yourself.moneyCards);
						
						for(var i:int = 0; i < currentMoneyCount; i++){
							moneyCard = new DisplayMoneyCard(currentMoneyCard.getValue+"",false);
							var yOffset:Number = i * - (4/1);
							moneyCard.y = yOffset;
							moneyCard.x = moneyCount * thisPlayerCardWidth;
							mainPlayerArea.moneyArea.addChild(moneyCard);
						}
						
						moneyCount ++;
						previousMoneyCard = currentMoneyCard.getValue;
					}
					
					
				}
				
				// add moneycard to show total money
			
				var totalMoneyCard:DisplayMoneyCard = new DisplayMoneyCard("money_back",false);
				totalMoneyCard.x = moneyCount * thisPlayerCardWidth;
				totalMoneyCard.draggable = false;
				
				// add text field to totalMoneyCard
				var totalTextField:TextField = new TextField(totalMoneyCard.width, totalMoneyCard.height*0.4,"", Config.fontName,14*Config.fontScaling,Config.yellowColor);
				totalTextField.text = gameModel.yourself.countMoney()+"";
				totalTextField.y = totalMoneyCard.height * 0.6;
				totalTextField.x = totalMoneyCard.x;
				
				mainPlayerArea.moneyArea.addChild(totalMoneyCard);
				
				mainPlayerArea.moneyArea.addChild(totalTextField);
				
				mainPlayerArea.moneyArea.x = (mainPlayerArea.width - mainPlayerArea.moneyArea.width) /2 ;
			}
		}
		
		private function showAnimalsListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				filter.adjustBrightness(-0.2);
				filter.resolution = 2;			
				
				(event.target as Image).filter = filter;
				//show animals
				
			}
			if(touch.phase == TouchPhase.ENDED){
				(event.target as Image).filter = null;
				
				if(mainPlayerArea.moneyShowing){
					showMoney();
				}
				showAnimals();
			}
		}
		private function showAnimals():void{
			
			if(gameModel.yourself.animalCards.length == 0){
				notification.showMessage(gameModel.yourself,"hebt nog geen dierkaarten!",true);
			}
			
			if(mainPlayerArea.animalsShowing){
				mainPlayerArea.animalsShowing = false;
				TweenLite.to(mainPlayerArea.animalArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
				//hide animals
			}else{
				mainPlayerArea.animalsShowing = true;
				//show animals
				
				drawPlayerCards();
				
				TweenLite.from(mainPlayerArea.animalArea,0.6,{y:game.stageHeight * Config.mainPlayerAreaHeight * 2.5});	
				
			}
		}
		
		private function drawPlayerCards():void{
			if(mainPlayerArea.animalsShowing){
				var sortedAnimalArray:Array = gameModel.yourself.animalCards;
				sortedAnimalArray.sort(sortByValue);
				
				//create animalCard to get size
				var animalCard:DisplayAnimalCard = new DisplayAnimalCard('animal_back',false);
				
				var previousAnimal:String = "";
				var animalCount:int = 0;
				mainPlayerArea.animalArea.removeChildren();
				mainPlayerArea.animalArea.y = (game.stageHeight * Config.mainPlayerAreaHeight - animalCard.height) /2;
				
				
				for(var y:int in sortedAnimalArray){
					//draw animal
	
					var currentAnimal:AnimalCard = (sortedAnimalArray[y] as AnimalCard);
					var thisPlayerCardWidth:Number = animalCard.width;
					var leftOffset:Number = mainPlayerArea.width * 0.15;
					
					var amountOfAnimals:int = CardManager.checkAmountOfDifferentAnimals(sortedAnimalArray);
					if(amountOfAnimals > 5){
						thisPlayerCardWidth = (mainPlayerArea.width*0.65)/(amountOfAnimals+1);
					}
					
					if(currentAnimal.name != previousAnimal){
						
						var currentAnimalCount:Number = CardManager.checkAmountForName(currentAnimal.name,gameModel.yourself.animalCards);
						
						for(var i:int = 0; i < currentAnimalCount; i++){
							animalCard = new DisplayAnimalCard(currentAnimal.name,false);
							var yOffset:Number = i * - (8/1);
							animalCard.y = yOffset;
							animalCard.x = animalCount * thisPlayerCardWidth;
							mainPlayerArea.animalArea.addChild(animalCard);
						}
						
						animalCount ++;
						previousAnimal = currentAnimal.name;
					}
					mainPlayerArea.animalArea.x = (mainPlayerArea.width - mainPlayerArea.animalArea.width) /2 ;
					
				}
			}
		}
		
		private function decreaseOffer(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				if(offerAmount > 10){
					offerAmount -= 10;
					updateOfferButtons();
				}
			}
		}
		private function increaseOffer(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				offerAmount += 10;
				updateOfferButtons();
			}
		}
		private function updateOfferButtons():void{
			//update offer button
			var totalOffer:int = (gameModel.getHighestBid()+offerAmount);
			makeOfferButton.text = "BIED "+totalOffer;
			
			//update offer button subtext
			makeOfferSubtext.text ="(+"+offerAmount+")";
			
			//update total money
			//moneyDisplay.text = "Geld: "+gameModel.yourself.countMoney();
			
			if(totalOffer > gameModel.yourself.countMoney()){
				makeOfferButton.alpha = 0.5;
			}else{
				makeOfferButton.alpha = 1;
			}
		}
		
		protected function animalSold(event:GameEvent):void
		{
			// hide auction bords
			for(var i:int in this.localPlayerAreas){
				var localPlayerArea:PlayerArea = this.localPlayerAreas[i];
				localPlayerArea.dismissAuctionBord();
			}
			
			// refresh animals
			drawAnimalCards();
			drawPlayerCards();
			
			auctionTime.visible = false;
			
			//remove donkey background if present
			if(donkeyBackdrop != null){
				removeChild(donkeyBackdrop,true);
				donkeyBackdrop == null;
			}
		
			soundPlayer.playHammer();
			
			mainPlayerArea.mainPlayerBidArea.visible = false;
			if(auctionCard){
				removeChild(auctionCard);
			}
			
			notification.showMessage(event.values['player'] as Player,"wint "+(event.values['animal'] as AnimalCard).dutchNameWithPrefix);
		}
		private function animalTraded(event:GameEvent):void{
			// refresh animals
			drawAnimalCards();
			drawPlayerCards();
			drawPlayerMoney();
			
			// hide all offers for localplayers
			for(var x:int in localPlayerAreas){
				var localPlayerArea:PlayerArea = localPlayerAreas[x];
				localPlayerArea.hideOffer();
			}
			
			notification.showMessage(event.values['player'] as Player,"wint "+(event.values['animal'] as AnimalCard).dutchNameWithPrefix);
		}
		
		private function drawAnimalCards():void
		{
			for(var x:int in logicalPlayerArray){
				
				var sortedAnimalArray:Array = (logicalPlayerArray[x] as Player).animalCards;
				sortedAnimalArray.sort(sortByValue);

				trace("(draw animal cards) ***start player***");
				var previousAnimal:String = "";
				var animalCount:int = 0;
				(localPlayerAreas[x] as PlayerArea).animalArea.removeChildren();

				for(var y:int in sortedAnimalArray){
					//draw animal
					
					//create animalCard to get size
					var animalCard:DisplayAnimalCard = new DisplayAnimalCard('animal_back',false);
					
					var currentAnimal:AnimalCard = (sortedAnimalArray[y] as AnimalCard);
					var thisPlayerCardWidth:Number = animalCard.width;
					
					var amountOfAnimals:int = CardManager.checkAmountOfDifferentAnimals(sortedAnimalArray);
					if(amountOfAnimals > 3){
						thisPlayerCardWidth = (game.stageHeight * Config.playerAreaWidth - animalCard.width)/(amountOfAnimals+1);
					}
					
					if(currentAnimal.name != previousAnimal){
						
						var currentAnimalCount:Number = CardManager.checkAmountForName(currentAnimal.name,(logicalPlayerArray[x] as Player).animalCards);
						
						for(var i:int = 0; i < currentAnimalCount; i++){
							animalCard = new DisplayAnimalCard(currentAnimal.name,false);
							var yOffset:Number = i * - (8/1);
							animalCard.y = (((game.stageHeight * Config.playerAreaHeight) - animalCard.height) / 2)+yOffset;
							animalCard.x = animalCount * thisPlayerCardWidth + animalCard.width;
							(localPlayerAreas[x] as PlayerArea).animalArea.addChild(animalCard);
						}

						animalCount ++;
						previousAnimal = currentAnimal.name;
					}
				}
				trace("(draw animal cards end)***end player***");


				
			}
		}
		private function sortByValue(a:*, b:*):int{
			var _a:AnimalCard = a;
			var _b:AnimalCard = b;
			
			if(_a.value > _b.value){
				return 1;
			}else if(_a.value < _b.value){
				return -1;		
			}
			return 0;
		}
		private function sortMoneyByValue(a:*, b:*):int{
			var _a:MoneyCard = a;
			var _b:MoneyCard = b;
			
			if(_a.getValue > _b.getValue){
				return 1;
			}else if(_a.getValue < _b.getValue){
				return -1;		
			}
			return 0;
		}
		private function highlightPlayer(playerUpNext:Player):void{
			// if mainPlayer was not previous player, remove active state from mainPlayerArea
			if(currentPlayerLocalIndex != -1){
				(localPlayerAreas[currentPlayerLocalIndex] as PlayerArea).makeInactive();
			}else{
				//self is inactive
				mainPlayerArea.makeInactive();
			}
			
			currentPlayerLocalIndex = modelToLocalIndex(playerUpNext);
			if(currentPlayerLocalIndex != -1){
				//active other player
				(localPlayerAreas[currentPlayerLocalIndex] as PlayerArea).makeActive();
			}else{
				//self is active player
				mainPlayerArea.makeActive();
			}
		}
		private function newTurn(event:GameEvent):void
		{
			//hide auction from previous turn
			auctionHighestBid.visible = false;
			auctionTime.visible = false;
			
			//reset offer amount
			offerAmount = 10;
			
			//update money
			updateMoney();
			
			var playerUpNext:Player = event.values['player'] as Player;
			
			highlightPlayer(playerUpNext);
			
			if(playerUpNext == gameModel.yourself){
				notification.showMessage(playerUpNext,"bent aan de beurt");
			}else{
				notification.showMessage(playerUpNext,"is aan de beurt");
			}
		
		}
		
		private function moneyUpdated(event:GameEvent):void{
			updateMoney();	
		}
		private function updateMoney():void{
			if(playerDecks.length > 0){
				for(var i:int in logicalPlayerArray){
					(playerDecks[i] as PlayerMoneyDeck).changeDeckCount((logicalPlayerArray[i] as Player).moneyCards.length);
				}
			}
		}
		
		private function auctionOfferUpdate(event:GameEvent):void
		{
			auctionHighestBid.text = "Hoogste bod: "+event.values['offer'];
			if(event.values['player'] != gameModel.yourself){
				//show offer board
				if(event.values['offer'] > 0){
					var localPlayerIndex:int = this.modelToLocalIndex(event.values['player']);
					(localPlayerAreas[localPlayerIndex] as PlayerArea).showOffer(event.values['offer']);
				}
			}
			
			// hide other boards
			for(var i:int in this.gameModel.getPlayers()){
				var player:Player = this.gameModel.getPlayers()[i];
				if(player != event.values['player'] && player != gameModel.yourself){						
					var tempLocalPlayerIndex:int = this.modelToLocalIndex(player);
					(localPlayerAreas[tempLocalPlayerIndex] as PlayerArea).dismissAuctionBord();
				}
			}

			updateOfferButtons();
		}
		
		private function updateAuctionTimer(event:GameEvent):void
		{
			auctionTime.text = event.values['timeLeft'];
			if(event.values['timeLeft'] == 3){
				soundPlayer.playClock();
			}
			if(event.values['timeLeft'] > 3){
				soundPlayer.stopClock();
			}
		}
		
		private function cardDrawn(event:GameEvent):void
		{
			if(gameModel.getAnimalDeck().length == 0){
				deckCard.visible = false;
				deckCounter.visible = false;
			}
			soundPlayer.playAnimalSound(event.values['animal']);
			
			deckCounter.text = gameModel.getAnimalDeck().length+"";
			
			auctionCard = new DisplayAnimalCard(event.values['animal']);
			auctionCard.x = game.stageWidth/2 + auctionCard.width*0.55;
			auctionCard.y = game.stageHeight/2;
			addChildAt(auctionCard,1);
			
			
			if(event.values['animal'] == 'donkey'){
				soundPlayer.playMoneySound();
				donkeyBackdrop = new DonkeyBackground();
				donkeyBackdrop.x = auctionCard.x;
				donkeyBackdrop.y = auctionCard.y;
				addChildAt(donkeyBackdrop,1);
			}
			
			
			//init auction elements
			auctionTime.visible = true;
			auctionHighestBid.visible = true;
			if(event.values['seller'] != gameModel.yourself){
				mainPlayerArea.mainPlayerBidArea.visible = true;
			}
			
			updateOfferButtons();
		}
		
		
		 
		private function deckIsPrepared(event:GameEvent):void
		{
			
			//prepare deck
			deckCard = new DisplayAnimalCard('animal_back');
			deckCard.x = game.stageWidth/2 - deckCard.width*0.55;
			deckCard.y = game.stageHeight/2;
			addChildAt(deckCard,1);
			
			// add counter
			deckCounter = new TextField(deckCard.width, deckCard.height /2,"40",Config.fontStrokedName,13*Config.fontScaling,0xffffff);
			deckCounter.x =	deckCard.x - deckCard.width/2;
			deckCounter.y = game.stageHeight/2 + deckCard.height * 0.05;
			addChild(deckCounter);	

			registerLocalPlayers();
			
		}
		private function localToModelIndex(localIndex:int):Player{
			var playerIndex:int = gameModel.getPlayers().indexOf(logicalPlayerArray[localIndex]);
			return (gameModel.getPlayers()[playerIndex] as Player);
		}
		private function modelToLocalIndex(modelPlayer:Player):int{
			return logicalPlayerArray.indexOf(modelPlayer);
		}
		public function unloadSinglePlayer():void{
			gameSongChannel.stop();
			gameModel.stop();
			game.unloadSinglePlayer();
		}
	}
}