package components
{
	import starling.text.TextField;
	
	public class AnimateableTextField extends TextField
	{
		public function AnimateableTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0, bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
		}
		
		public function set numberText(number:Number):void{
			this.text =""+Math.round(number);
		}
		public function get numberText():Number{
			return Number(this.text);
		}
	}
}