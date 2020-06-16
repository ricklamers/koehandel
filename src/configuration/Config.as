package configuration
{
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;

	public class Config
	{
		
		//colors
		
		static public var redColor:int = 0xc82538;
		static public var redColorRGBA:Number = 0xffc82538;
		static public var darkRedColorRGBA:Number = 0xff950005;
		static public var yellowColor:int = 0xf1c11f;
		static public var darkRedColor:int = 0x950005;
		static public var borderThickness:Number = 4;
		static public var fontName:String = "Gabriele Bad AH";
		static public var normalFontName:String = "Arial";
		static public var fontStrokedName:String = "Gabriele Bad AH Stroked";
		static public var menuHeight:Number = 0.13; // 9% of screen
		static public var playerAreaWidth:Number = 0.7; // 30 % of screenHeight
		static public var playerAreaHeight:Number = 0.3; // 70 % of screenHeight
		static public var mainPlayerAreaHeight:Number = 0.3;
		static public var auctionLength:Number = 6000;
		
		// double font size for desktop for correct PPI scaling
		static public var fontScaling:Number = 1;
		//if(Capabilities.touchscreenType == TouchscreenType.NONE){
			//fontScaling *= 2;
		//}
		
		static public const GameDifficulty_NORMAL:int = 20;
		static public const GameDifficulty_HARD:int = 30;
		public static const BulletSize:Number = 8;
		public static var winGoldColor:uint = 0xffb400;
		public static var winSilverColor:uint = 0xa0a0a0;
		public static var winBronzeColor:uint = 0xcd7f32;
		public static var winMedalSize:Number = 50;
		
		
		
		public function Config()
		{
			// helper class with config
			
		}
	}
}