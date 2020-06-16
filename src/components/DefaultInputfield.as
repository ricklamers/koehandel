package components
{
	import com.adobe.utils.NativeText;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.ReturnKeyLabel;
	
	import configuration.Config;
	
	public class DefaultInputfield extends Sprite
	{

		private var textField:NativeText;

		private var initialText:String;

		private var backgroundSprite:Sprite;

		private var PdesiredHeight:Number;

		private var PcontentScaleFactor:Number;
		public function DefaultInputfield(desiredWidth:Number, desiredHeight:Number, fontSize:Number, contentScaleFactor:Number, initText:String, password:Boolean = false)
		{
			super();
			
			var borderThickness:Number = Config.borderThickness;
			
			backgroundSprite = new Sprite();
			// dark bg
			backgroundSprite.graphics.beginFill(0x000000,0.8);
			backgroundSprite.graphics.drawRect(borderThickness, borderThickness, desiredWidth * contentScaleFactor, desiredHeight * contentScaleFactor);
			// yellow border
			backgroundSprite.graphics.beginFill(Config.yellowColor);
			backgroundSprite.graphics.drawRect(0, 0, desiredWidth * contentScaleFactor, desiredHeight * contentScaleFactor);
			// white fill
			backgroundSprite.graphics.beginFill(0xffffff);
			backgroundSprite.graphics.drawRect(borderThickness, borderThickness, desiredWidth * contentScaleFactor - borderThickness*2, desiredHeight * contentScaleFactor - borderThickness*2);
			
			addChild(backgroundSprite);
			
			initialText = initText.toUpperCase();
			
			PdesiredHeight = desiredHeight;
			PcontentScaleFactor = contentScaleFactor;
			
			textField = new NativeText(1);
			textField.returnKeyLabel = ReturnKeyLabel.DONE;
			textField.autoCorrect = false;
			textField.fontFamily = "GabrieleBadTTF";
			textField.fontSize = fontSize*2;
			textField.displayAsPassword = password;
			textField.color = 0x777777;
			textField.textAlign = "center";
			textField.y = desiredHeight * 0.25 * contentScaleFactor;
			textField.width = desiredWidth * contentScaleFactor;
			textField.text = initText.toUpperCase();
			textField.addEventListener(FocusEvent.FOCUS_IN, focusInListener);
			textField.addEventListener(FocusEvent.FOCUS_OUT, focusOutListener);
			addChild(textField);
	
			
		}
		public function set setX(x:Number):void
		{
			backgroundSprite.x = x * PcontentScaleFactor;
			textField.x = x * PcontentScaleFactor;
		}
		public function set setY(y:Number):void
		{
			backgroundSprite.y = y * PcontentScaleFactor;
			textField.y = y * PcontentScaleFactor + (PdesiredHeight * 0.25 * PcontentScaleFactor);
		}
		public function get setY():Number
		{
			return backgroundSprite.y / PcontentScaleFactor;
		}
		public function get setX():Number
		{
			return backgroundSprite.x / PcontentScaleFactor;
		}
		public function get value():String{
			return textField.text;
		}
		public function hide():void{
			textField.visible = false;
			visible = false;
		}
		public function show():void{
			textField.visible = true;
			visible = true;
		}
		
		protected function focusInListener(event:FocusEvent):void
		{
			if(textField.text == initialText){
				textField.text = "";
				textField.color = 0x000000;
			}
		}
		protected function focusOutListener(event:FocusEvent):void
		{
			if(textField.text == ""){
				textField.text = initialText;
				textField.color = 0x777777;
			}
		}
	}
}