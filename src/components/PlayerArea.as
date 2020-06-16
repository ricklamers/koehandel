package components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class PlayerArea extends Sprite
	{

		private var highLight:Image;

		private var isActive:Boolean;

		public var animalArea:Sprite;

		public var auctionBoard:AuctionBord;

		private var game:Game;

		private var effectSprite:Sprite;

		public var playerDeck:PlayerMoneyDeck;

		private var area:Image;
		public var playerDeckCallback:Function;

		private var auctionBoardY:Number;

		private var tradeOfferArea:Sprite;
		public function PlayerArea()
		{
			super();

			effectSprite = new Sprite();
			tradeOfferArea = new Sprite();
			game = Game.getGame();
			area = new Image(Texture.fromColor(game.stageHeight * Config.playerAreaWidth,game.stageHeight * Config.playerAreaHeight,0x55ffffff,false,1));
			
			auctionBoard = new AuctionBord();
			auctionBoard.x = (area.width - auctionBoard.width) /2;
			auctionBoard.visible = true;
			auctionBoard.y = area.height;
			auctionBoardY = area.height - auctionBoard.height;
			addChild(area);
			addChild(effectSprite);
			animalArea = new Sprite();
			addChild(animalArea);
			addChild(tradeOfferArea);
			isActive = false;
			
			playerDeck = new PlayerMoneyDeck();
			playerDeck.x = 0;
			playerDeck.y = (area.height - playerDeck.height)/2;
			playerDeck.addEventListener(TouchEvent.TOUCH,playerDeckTouch);
					
			highLight = new Image(game.assets.textureAtlas1.getTexture("filter_blur"));
			
			highLight.visible = false;
			highLight.alpha = 0;
			highLight.blendMode = BlendMode.ADD;
				
			area.visible = false;
			pivotX = width /2;
			pivotY = height /2;
			
			

		}
		
		private function playerDeckTouch(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				if(this.playerDeckCallback){
					this.playerDeckCallback();
				}
			}
		}
		public function showOffer(offer:Number):void{
			
			if(auctionBoard.y == auctionBoardY){
				TweenLite.to(auctionBoard,0.1,{y:area.height, onComplete:function():void{
					TweenLite.to(auctionBoard,0.2,{y:auctionBoardY, onComplete:function():void{
						auctionBoard.scoreField.text = ""+offer;
					}});
				}
				});
			}else{
				auctionBoard.scoreField.text = ""+offer;
				TweenLite.to(auctionBoard,0.2,{y:auctionBoardY, onComplete:function():void{
				
				}});
			}
			
		}
		public function dismissAuctionBord():void{
			TweenLite.to(auctionBoard,0.2,{y:area.height});
		}
		public function showTradeOffer(count:Number):void{
			var leftOffset:Number = area.width * 0.4;
			var totalWidth:Number = area.width * 0.4;
			var positionIncrement:Number = totalWidth / count;
			
			var rotationAmount:Number = 30;
			var rotationIncrement:Number = (rotationAmount * 2) / count;
			if(count < 3){
				rotationAmount = 0;
				rotationIncrement = 0;
			}
			
			for(var x:int = 0; x < count; x++){
				var thisCard:DisplayMoneyCard = new DisplayMoneyCard('money_back',true);
				thisCard.x = leftOffset + positionIncrement * x;
				thisCard.y = area.height - thisCard.height * 0.1 + area.height;
				if(x == 0 && count < 9 || x == count-1 && count < 9){
					thisCard.y = area.height + area.height;
				}
				thisCard.rotation = deg2rad(-rotationAmount + (rotationIncrement * x));
				tradeOfferArea.addChild(thisCard);
			}
			
			animateTradeOffer();
	
		}
		private function animateTradeOffer():void{
			var animationDelay:Number = 0;
			
			var numChildren:Number = tradeOfferArea.numChildren;
			for(var x:int = 0; x < numChildren; x++){
				var card:DisplayMoneyCard = tradeOfferArea.getChildAt(x) as DisplayMoneyCard;
				TweenLite.to(card, 1, {y: card.y - area.height, delay: animationDelay, ease:Elastic.easeOut});
				animationDelay += 0.08;
			}			
		}
		public function init():void{
			highLight.y = 30;	
			highLight.visible = true;
			highLight.x = - highLight.width * 0.1;
			highLight.width = game.stageHeight * 0.9;
			effectSprite.addChild(highLight);
			addChild(auctionBoard);
			addChildAt(playerDeck,2);

		}
		private function animatePulse():void{
			TweenLite.to(highLight,0.4,{alpha:0.7, onComplete:function():void{
				TweenLite.to(highLight,0.4,{alpha:0,onComplete:function():void{
					if(isActive){
						animatePulse();
					}
				}
				});
			}
			});
		}
		public function makeActive():void{
			isActive = true;
			TweenLite.to(highLight,0.4,{alpha:0.3});
		}
		public function makeInactive():void{
			isActive = false;
			TweenLite.to(highLight,0.4,{alpha:0});
		}
		
		public function hideOffer():void
		{
			if(tradeOfferArea.numChildren > 0){
				TweenLite.to(tradeOfferArea, 0.4, {y: area.height, onComplete:function():void{
					tradeOfferArea.removeChildren();
					tradeOfferArea.y = 0;
				} 
				});
			}
		}
	}
}