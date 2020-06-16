package components
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class BadgeImage extends Image
	{
		public var outsideX:Number;
		public var outsideY:Number;
		private var i_insideX:Number;
		private var i_insideY:Number;
		
		public function BadgeImage(texture:Texture)
		{
			super(texture);
			
			// bound to pixel size
			this.width = Math.min(this.width, 120);
			this.height = Math.min(this.height, 120);
			
		}
		
		public function set insideX(x:Number):void{
			this.x = x;
			this.i_insideX = x;
		}
		public function set insideY(y:Number):void{
			this.y = y;
			this.i_insideY = y;
		}
		public function get insideX():Number{
			return this.i_insideX;
		}
		public function get insideY():Number{
			return this.i_insideY;
		}
	}
}