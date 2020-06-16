package components
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import configuration.Config;
	
	import model.Player;
	import model.SinglePlayerModel;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Notification extends starling.display.Sprite
	{

		private var notificationArray:Array;

		private var showingMessage:Boolean;

		private var nameTextField:TextField;

		private var messageTextField:TextField;

		private var playerImage:Image;

		private var game:Game;

		private var backgroundImage:Image;
		public function Notification()
		{
			super();
			game = Game.getGame();
			
			var desiredWidth:Number = game.stageWidth * 0.6;
			var desiredHeight:Number = game.stageWidth * 0.1;
			var backgroundSprite:flash.display.Sprite = new flash.display.Sprite();
			backgroundSprite.graphics.beginFill(0x000000,0.8);
			backgroundSprite.graphics.drawRect(Config.borderThickness,Config.borderThickness,desiredWidth*1, 1*desiredHeight);
			backgroundSprite.graphics.beginFill(Config.redColor);
			backgroundSprite.graphics.drawRect(0,0,desiredWidth*1, 1*desiredHeight);
			backgroundSprite.graphics.beginFill(Config.redColor);
			backgroundSprite.graphics.drawRect(Config.borderThickness,Config.borderThickness,desiredWidth*1-Config.borderThickness*2,desiredHeight*1-Config.borderThickness*2);
			
			var bitmapData:BitmapData = new BitmapData(desiredWidth*1 + Config.borderThickness, desiredHeight*1 + Config.borderThickness, true,0);
			bitmapData.draw(backgroundSprite);
			var texture:Texture = Texture.fromBitmapData(bitmapData,false,false,1);
			backgroundImage = new Image(texture);
			
			nameTextField = new TextField(desiredWidth,desiredHeight*0.5,"Tim te Weenegouwen");
			nameTextField.color = 0xffffff;
			nameTextField.y = backgroundImage.height * 0.1;
			nameTextField.fontSize = 16 * Config.fontScaling;
			nameTextField.bold = true;
			nameTextField.vAlign = 'top';
			nameTextField.fontName = Config.normalFontName;
			
			messageTextField = new TextField(desiredWidth,desiredHeight*0.6,"is aan de beurt");
			messageTextField.color = 0xffffff;
			messageTextField.y = backgroundImage.height * 0.5;
			messageTextField.fontSize = 13 * Config.fontScaling;
			messageTextField.vAlign = 'top';
			messageTextField.fontName = Config.normalFontName;
			
			
			//playerImage
			playerImage = new Image(game.assets.textureAtlas1.getTexture("farmer3"));
			playerImage.width = backgroundImage.height * 0.8;
			playerImage.height = backgroundImage.height * 0.8;
			playerImage.y = (backgroundImage.height*0.95 - playerImage.height) /2;
			playerImage.x = backgroundImage.width * 0.05;
			
			addChild(backgroundImage);
			addChild(playerImage);
			addChild(nameTextField);
			addChild(messageTextField);
			
			// hide itself
			y = - backgroundImage.height;
			
			notificationArray = [];
			
			showingMessage = false;
			
		}
		public function showMessage(targetPlayer:Player, message:String, autoHide:Boolean = true):void{
			
			if(!showingMessage){
				showingMessage = true;
				var playerName:String = targetPlayer.getName();
				if(playerName.length > 20){
					playerName.substr(0,18) + "...";
				}
				nameTextField.text = playerName;
				messageTextField.text = message;
				playerImage.texture = game.assets.getTextureForName(targetPlayer.profileImage);
				
				var self:Notification = this;
				TweenLite.to(this,((Config.auctionLength * 0.02)/1000),{y:0, onComplete:function():void{
					if(autoHide){
						TweenLite.to(self,((Config.auctionLength * 0.02)/1000),{y:-backgroundImage.height, delay:Config.auctionLength  / 4 /1000, onComplete:function():void{
							showingMessage = false;
							if(notificationArray.length > 0){
								var firstNotificationInLine:PendingNotification = notificationArray[0];
								notificationArray.shift();
								showMessage(firstNotificationInLine.targetPlayer, firstNotificationInLine.message, firstNotificationInLine.autoHide);
							}
						}
						});
					}
				}
				});

			}else{
				notificationArray.push(new PendingNotification(targetPlayer,message));
			}
			
		}
	}
}