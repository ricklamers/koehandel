package textures
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class CircleTexture extends Texture
	{
		public function CircleTexture()
		{
			super();
		}
		
		static public function MakeCircleTexture(color:uint, size:Number):Texture{
			var desiredWidth:Number = size * 1;
			var desiredHeight:Number = size * 1;
			var shadowOffset:Number = 1 * 1;
			var circle:flash.display.Sprite = new flash.display.Sprite();
			circle.graphics.beginFill(0x000000,0.8);
			circle.graphics.drawCircle(desiredWidth/2+shadowOffset, desiredWidth/2+shadowOffset,desiredWidth/2);
			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(desiredWidth/2, desiredWidth/2,desiredWidth/2);
			
			var bitmapData:BitmapData = new BitmapData(desiredWidth + shadowOffset, desiredHeight + shadowOffset, true,0);
			bitmapData.draw(circle);
			return Texture.fromBitmapData(bitmapData,false,false,1);
		}
	}
}