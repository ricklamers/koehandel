package screens.menu
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import components.AnimateableTextField;
	
	import configuration.Config;
	
	import interfaces.GameScreen;
	
	import model.Player;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Uitslag extends GameScreen
	{

		private var medalStars:Array;
		public function Uitslag(players:Array)
		{
			super();
			screenTitle = "Uitslag";
			var game:Game = Game.getGame();

			var winnerBars:Array = [];
			var scoreFields:Array = [];
			var leftOffset:Number = game.stageWidth * 0.2;
			var animationDuration:Number = 5;
			var winnerPhotos:Array = [];
			medalStars = [];
			
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
			
			
			var startPercentage:Number = 0.20;
			
			var sortedPlayerArray:Array = players.concat();
			sortedPlayerArray.sort(sortPlayers);


			
			for(var x:int in players){
				var player:Player = players[x];
				var number:Number = player.totalScore;
				var percentage:Number = number / (sortedPlayerArray[3] as Player).totalScore;
				
				var winnerBarImage:Image = new Image(game.assets.winBar);
				var winnerBar:Sprite = new Sprite();
				var scoreField:AnimateableTextField = new AnimateableTextField(winnerBarImage.width, game.stageHeight * 0.1,"0",Config.fontName,13*Config.fontScaling,0xffffff);
				var scoreFieldHolder:Sprite = new Sprite();
				scoreField.y = winnerBarImage.height * 0.83;
				winnerBar.addChild(winnerBarImage);
				scoreFieldHolder.addChild(scoreField);
				winnerBar.addChild(scoreFieldHolder);
				
				var winnerProfileImage:Image = new Image(game.assets.getTextureForName(player.profileImage));
				var winnerProfileImageHolder:Sprite = new Sprite();
				winnerProfileImage.height = winnerProfileImage.width = winnerProfileImage.width*0.65;
				winnerProfileImageHolder.x = leftOffset +((winnerBarImage.width - winnerProfileImage.width)/2) + x * game.stageWidth * 0.15;
				winnerProfileImageHolder.y = game.stageHeight * 0.15;
				winnerProfileImageHolder.addChild(winnerProfileImage);
				
				//add medals	
				var medalImage:Image = null;
				switch(player){
					case sortedPlayerArray[3]:
						// ad gold medal
						medalImage = new Image(game.assets.firstPrizeCircle);
						break;
					case sortedPlayerArray[2]:
						// ad silver medal
						medalImage = new Image(game.assets.secondPrizeCircle);
						break;
					case sortedPlayerArray[1]:
						// ad bronze medal
						medalImage = new Image(game.assets.thridPrizeCircle);
						break;
				}
				
				if(medalImage != null){
					var medal:Sprite = new Sprite();
					medal.addChild(medalImage);
					medal.y = medal.height;
					medal.x = -medal.width * 1;
					var medalStar:Image = new Image(game.assets.textureAtlas1.getTexture("star"));
					medalStar.x = medal.width * 0.48; 
					medalStar.y = medal.height * 0.48;
					medalStar.pivotX = medalStar.width*.50;
					medalStar.pivotY = medalStar.height*.55;
					medal.addChild(medalStar);
					medalStars.push(medalStar);
					winnerProfileImageHolder.addChild(medal);					
				}
				if(medalImage){
					TweenLite.from(medal,0.4,{alpha:0, delay:animationDuration*percentage});
				}
				
				// end of medals
				
				winnerBar.x = leftOffset + x * game.stageWidth * 0.15;
				winnerBar.y = game.stageHeight * 0.25;
				winnerBar.clipRect = new Rectangle(0,winnerBarImage.height * (1-startPercentage),winnerBarImage.width, winnerBarImage.height - winnerBarImage.height * (1-startPercentage));
				addChild(winnerBar);
				
				addChild(winnerProfileImageHolder);
				
				// minus 5 % for consistent tops
				TweenLite.to(winnerBar.clipRect, animationDuration ,{top: winnerBar.clipRect.top - winnerBarImage.height * (1-startPercentage-0.05), ease:Linear.easeNone});
				winnerBars.push(winnerBar);
				TweenLite.from(winnerProfileImageHolder, animationDuration,{y:game.stageHeight * 0.15 + winnerBarImage.height * (1-startPercentage - 0.05), ease:Linear.easeNone});
				scoreFields.push(scoreFieldHolder);
				
				winnerPhotos.push(winnerProfileImageHolder);
				
				
				
				var animTime:Number = animationDuration * 1000 * percentage;
				TweenLite.to(scoreFieldHolder,animationDuration,{y:-(winnerBarImage.height - scoreField.height)/2, ease:Linear.easeNone});			
				TweenLite.to(scoreField, animTime/1000,{numberText:number, ease:Linear.easeNone});
				
				
				setTimeout(function(x):void{
					var index:Number = x;
					TweenLite.killTweensOf((winnerBars[index] as Sprite).clipRect);
					TweenLite.killTweensOf((scoreFields[index] as DisplayObject));
					TweenLite.killTweensOf((winnerPhotos[index] as DisplayObject));
					
				},animationDuration*1000*percentage,x);
				
			}
			
		}
		private function sortPlayers(a:*, b:*):int{
			var player1:Player = a;
			var player2:Player = b;
			
			if(player1.totalScore > player2.totalScore){
				return 1;
			}else if (player1.totalScore == player2.totalScore){
				return 0;
			}
			else{
				return -1;
			}
		}
		
		private function enterFrameListener():void
		{
			// TODO Auto Generated method stub
			
			for(var x:int in this.medalStars){
				var medalStar:Image = medalStars[x];
				medalStar.rotation += 0.03;
			}
			
		}		

	}
}