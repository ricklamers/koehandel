package managers
{
	import flash.media.Sound;
	
	import components.ProfileImage;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import textures.CircleTexture;
	import textures.MenuBar;
	import textures.Rectangle;

	public class Assets
	{
		[Embed(source="../../assets/cow_skin.png")]
		static public var CowBG:Class;
		
		[Embed(source="../../assets/background.jpg")]
		static public var MainBG:Class;
		
		[Embed(source="../../assets/texture_atlas.png")]
		static public var TextureAtlas1Bitmap:Class;
		
		[Embed(source="../../assets/texture_atlas.xml", mimeType = "application/octet-stream")]
		static public var TextureAtlasXML1:Class; 
		
		[Embed(source="../../assets/card_atlas.png")]
		static public var TextureAtlasCardBitmap:Class;
		
		[Embed(source="../../assets/card_atlas.xml", mimeType = "application/octet-stream")]
		static public var TextureAtlasCardXML:Class; 
		
		[Embed(source="../../assets/sounds/intro-song.mp3")]
		static public var SoundIntroSong:Class; 
		
		[Embed(source="../../assets/sounds/game_music.mp3")]
		static public var SoundGameSong:Class; 
		
		//animal sounds
		[Embed(source="../../assets/sounds/animal_sounds/cat.mp3")]
		static public var AnimalSoundCat:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/goat.mp3")]
		static public var AnimalSoundGoat:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/chicken.mp3")]
		static public var AnimalSoundChicken:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/cow.mp3")]
		static public var AnimalSoundCow:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/dog.mp3")]
		static public var AnimalSoundDog:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/duck.mp3")]
		static public var AnimalSoundDuck:Class;
		[Embed(source="../../assets/sounds/animal_sounds/donkey.mp3")]
		static public var AnimalSoundDonkey:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/horse.mp3")]
		static public var AnimalSoundHorse:Class;
		[Embed(source="../../assets/sounds/animal_sounds/pig.mp3")]
		static public var AnimalSoundPig:Class; 
		[Embed(source="../../assets/sounds/animal_sounds/sheep.mp3")]
		static public var AnimalSoundSheep:Class;
		
		[Embed(source="../../assets/sounds/hammer.mp3")]
		static public var HammerSound:Class;
		
		[Embed(source="../../assets/sounds/clock.mp3")]
		static public var ClockSound:Class;
	
		[Embed(source="../../assets/sounds/button_sound.mp3")]
		static public var ButtonSoundEffect:Class; 
		
		[Embed(source="../../assets/sounds/money_sound.mp3")]
		static public var MoneySoundEffect:Class; 
		
		[Embed(source="../../assets/fonts/gabriele-bad.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		[Embed(source = "../../assets/fonts/gabriele-bad.png")]
		public static const FontTexture:Class;
		
		[Embed(source="../../assets/fonts/gabriele-bad-stroked.fnt", mimeType="application/octet-stream")]
		public static const FontStrokedXml:Class;
		
		[Embed(source = "../../assets/fonts/gabriele-bad-stroked.png")]
		public static const FontStrokedTexture:Class;
		
		// embed configuration XML
		[Embed(source="../../assets/particles/money.pex", mimeType="application/octet-stream")]
		public static const MoneyParticleConfig:Class;
		
		// embed particle texture
		[Embed(source = "../../assets/particles/money.png")]
		public static const MoneyParticle:Class;
		
		[Embed(source="../../assets/fonts/gabriele-bad.ttf", 
    fontName = "GabrieleBadTTF", 
    mimeType = "application/x-font", 
    fontWeight="normal", 
    fontStyle="normal", 
    unicodeRange="U+0020-007E", 
    advancedAntiAliasing="true", 
    embedAsCFF="false")]
		
		public static const GabrieleBadTTF:Class;
		

		public var textureAtlas1:TextureAtlas;

		public var menuBarTexture:Texture;

		public var mainBG:Texture;

		public var cardTextureAtlas:TextureAtlas;

		public var buttonSound:Sound;

		private var profileImageArray:Array;

		public var redCircleTexture:Texture;
		
		public var whiteCircleTexture:Texture;

		public var firstPrizeCircle:Texture;

		public var secondPrizeCircle:Texture;

		public var thridPrizeCircle:Texture;

		public var winBar:Texture;


		public function Assets()
		{
			var game:Game = Game.getGame();
			//init starling requiring assets (e.g. TextureAtlas)
			var atlasXML:XML = new XML(new Assets.TextureAtlasXML1);
			var scale:Number = 1;		
			textureAtlas1 = new TextureAtlas(Texture.fromBitmap(new TextureAtlas1Bitmap,false,false,1),atlasXML);
			
			var cardAtlasXML:XML = new XML(new Assets.TextureAtlasCardXML);
			cardTextureAtlas = new TextureAtlas(Texture.fromBitmap(new TextureAtlasCardBitmap,false,false,scale),cardAtlasXML);
			
			var texture:Texture = Texture.fromBitmap(new FontTexture(),false,false, 1);
			var xml:XML = XML(new FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			var textureStroked:Texture = Texture.fromBitmap(new FontStrokedTexture(),false,false, 1);
			var xmlStroked:XML = XML(new FontStrokedXml());
			TextField.registerBitmapFont(new BitmapFont(textureStroked, xmlStroked));
			
			mainBG = Texture.fromBitmap(new MainBG);			
			
			menuBarTexture = new MenuBar().getTexture();
			
			buttonSound = new ButtonSoundEffect();
			profileImageArray = [];
			
			// help circle textures
			redCircleTexture = CircleTexture.MakeCircleTexture(Config.redColor,Config.BulletSize);
			whiteCircleTexture = CircleTexture.MakeCircleTexture(0xffffff,Config.BulletSize);
			
			
			// win screen textures
			firstPrizeCircle = CircleTexture.MakeCircleTexture(Config.winGoldColor, Config.winMedalSize / 1);
			secondPrizeCircle = CircleTexture.MakeCircleTexture(Config.winSilverColor, Config.winMedalSize / 1);
			thridPrizeCircle = CircleTexture.MakeCircleTexture(Config.winBronzeColor, Config.winMedalSize / 1);
			
			winBar = Rectangle.MakeRectangle(game.stageWidth * 0.14,game.stageHeight * 0.5, Config.redColor);

		}
		
		public function getTextureForName(profileImageName:String):Texture
		{
			// TODO -> support URL image textures
			var texture:Texture;
			for(var x:int in profileImageArray){
				var profileImage:ProfileImage = profileImageArray[x];
				if(profileImage.profileImageName == profileImageName){
					texture = profileImage.profileImageTexture;
				}
			}
			if(texture == null){
				//texture doesnt exist, create it and add to array
				var newProfileImage:ProfileImage = new ProfileImage(profileImageName,textureAtlas1.getTexture(profileImageName));
				profileImageArray.push(newProfileImage);
				texture = newProfileImage.profileImageTexture;
			}
			return texture;
		}
	}
}