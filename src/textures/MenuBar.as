package textures
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.textures.Texture; 
	
	public class MenuBar extends starling.textures.Texture
	{

		private var texture:Texture;
		
		public function MenuBar()
		{
			super();
			
			var desiredWidth:Number = Starling.current.stage.stageWidth;
		    var desiredHeight:Number = Starling.current.stage.stageHeight * Config.menuHeight;
			var backgroundSprite:flash.display.Sprite = new flash.display.Sprite();
			backgroundSprite.graphics.beginFill(0x000000,0.8);
			backgroundSprite.graphics.drawRect(0,Config.borderThickness,desiredWidth*1, 1*desiredHeight);
			backgroundSprite.graphics.beginFill(Config.redColor);
			backgroundSprite.graphics.drawRect(0,0,desiredWidth*1,desiredHeight*1);
			
			var bitmapData:BitmapData = new BitmapData(desiredWidth, desiredHeight + Config.borderThickness, true,0);
			bitmapData.draw(backgroundSprite);
			
			texture = Texture.fromBitmapData(bitmapData,false,false,1);
	
		}
		public function getTexture():Texture{
			return texture;
		}
	}
}