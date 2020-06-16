package textures
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import configuration.Config;
	
	import starling.core.Starling;
	import starling.textures.Texture;


	public class Rectangle
	{
		public function Rectangle()
		{
		}
		static public function MakeRectangle(width:Number, height:Number, color:uint):Texture{
			var desiredWidth:Number = width * 1;
			var desiredHeight:Number = height * 1;
			var rectangle:flash.display.Sprite = new flash.display.Sprite();
			rectangle.graphics.beginFill(0x000000,0.8);
			rectangle.graphics.drawRect(Config.borderThickness,Config.borderThickness,desiredWidth, desiredHeight);
			rectangle.graphics.beginFill(color);
			rectangle.graphics.drawRect(0,0,desiredWidth, desiredHeight);
			
			var bitmapData:BitmapData = new BitmapData(desiredWidth + Config.borderThickness, desiredHeight + Config.borderThickness, true,0);
			bitmapData.draw(rectangle);
			return Texture.fromBitmapData(bitmapData,false,false,1);
		}
	}
}