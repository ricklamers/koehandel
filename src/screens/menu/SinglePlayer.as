package screens.menu
{
	import components.DefaultButton;
	
	import configuration.Config;
	
	import interfaces.GameScreen;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class SinglePlayer extends GameScreen
	{

		private var game:Game;
		public function SinglePlayer()
		{
			super();
			
			game = Game.getGame();
			
			screenTitle = "Single player";
			
			var normaalButton:DefaultButton = new DefaultButton(game.stageWidth * 0.2,game.stageWidth * 0.1, "Normaal", 13, Config.redColor);
			normaalButton.y = (game.stageHeight-Config.menuHeight*game.stageHeight) * 0.5;
			normaalButton.x = game.stageWidth/2 - (normaalButton.width*1.5 / 2);
			normaalButton.addEventListener(TouchEvent.TOUCH, touchNormaal);
			addChild(normaalButton);
			
			var moeilijkButton:DefaultButton = new DefaultButton(game.stageWidth * 0.2,game.stageWidth * 0.1, "Moeilijk", 13, Config.redColor);
			moeilijkButton.y = (game.stageHeight-Config.menuHeight*game.stageHeight) * 0.5;
			moeilijkButton.x = normaalButton.x + game.stageWidth * 0.05 + moeilijkButton.width;
			moeilijkButton.addEventListener(TouchEvent.TOUCH, touchMoeilijk);
			addChild(moeilijkButton);

		}

		private function touchNormaal(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				game.startSinglePlayer(Config.GameDifficulty_NORMAL);
			}
		}
		private function touchMoeilijk(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			if(touch.phase == TouchPhase.ENDED){
				game.startSinglePlayer(Config.GameDifficulty_HARD);
			}
		}
	}
}