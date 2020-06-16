package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import interfaces.GameScreen;
	
	import managers.Assets;
	
	import screens.Menu;
	import screens.SinglePlayerGame;
	import screens.Startscreen;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class Game extends Sprite
	{	
		public var stageWidth:Number;
		public var stageHeight:Number;
		public var showingScreen:GameScreen = new GameScreen();
		public var assets:Assets;
		public var showingScreenName:String = "";

		private var introSong:Sound;

		public var singlePlayerGameScreen:SinglePlayerGame;

		private var introSongChannel:SoundChannel;
		
		public function Game()
		{
			super();
			
			
		}
		public function init():void{
			stageWidth = Starling.current.stage.stageWidth;
			stageHeight = Starling.current.stage.stageHeight;
			
			//init intro song
			introSong = new Assets.SoundIntroSong();
			introSongChannel = introSong.play(0,99999);
			
			TweenPlugin.activate([SoundTransformPlugin]);
			
			//init assets
			assets = new Assets();
			gotoScreen('startscreen');
//			gotoScreen('menu');
			//startSinglePlayer(Config.GameDifficulty_EASY);
		}
		
		public function gotoScreen(newScreen):void{
			showingScreen.prepareForDeletion();
			removeChild(showingScreen,true);
			
			showingScreenName = newScreen;

			switch(newScreen){
				case "startscreen":
					showingScreen = new Startscreen();
					showingScreen.init();
					addChild(showingScreen);
					break;
				case "menu":
					showingScreen = new Menu();
					showingScreen.init();
					//TweenLite.to(introSongChannel,0,{soundTransform:{volume:0}, ease:Quad.easeOut});
					TweenLite.to(introSongChannel,4,{soundTransform:{volume:1}, ease:Quad.easeOut});
					addChild(showingScreen);
					break;
				case "none":
					break;
			}
		}
		
		public function startSinglePlayer(difficulty:int):void{
			gotoScreen('none');
			singlePlayerGameScreen = new SinglePlayerGame(difficulty);
			
			TweenLite.to(introSongChannel,0,{soundTransform:{volume:0}, ease:Quad.easeOut});
			addChild(singlePlayerGameScreen);
		}
		
		static public function getGame():Game{
			return Starling.current.root as Game;
		}
		
		public function unloadSinglePlayer():void
		{
			this.removeChild(singlePlayerGameScreen, true);
		}
	}
}