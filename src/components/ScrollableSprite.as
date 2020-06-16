package components
{
	import com.greensock.TweenLite;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import events.ScrollEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ScrollableSprite extends Sprite
	{

		private var mTouching:Boolean;

		private var lastScrollDistance:Number;

		private var touchEndTimeout:uint;

		private var game:Game;

		public var maxSlideIndex:int;
		public function ScrollableSprite()
		{
			super();
			
			game = Game.getGame();
			//init scroll vars
			mTouching = false;
			lastScrollDistance = 0;

			addEventListener(TouchEvent.TOUCH, touchListener);
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
			
			
			
		}
		
		private function enterFrameListener(event:Event):void
		{
			if(!mTouching){
				var dampeningFactor:Number = 0.95;
				lastScrollDistance *= dampeningFactor;
				if(Math.abs(lastScrollDistance) < 0.5){
					lastScrollDistance = 0;
				}
				x += lastScrollDistance;
			}
		}
		
		private function touchListener(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			
			if(touch.phase == TouchPhase.BEGAN){
				clearTween();
				mTouching = true;
			}
			if(touch.phase == TouchPhase.MOVED){
				lastScrollDistance = touch.getLocation(this).x - touch.getPreviousLocation(this).x;
				x += lastScrollDistance;
			}
			if(touch.phase == TouchPhase.ENDED){
				mTouching = false;
				
				var self:ScrollableSprite = this;
				setTimeout(function():void{
					mTouching = true;
					
					var index:int = Math.floor(Math.abs(x) / game.stageWidth);
					var moduloLeft:Number = Math.abs(x) % game.stageWidth;
					var moduleDivision:Number = Math.round(moduloLeft / game.stageWidth);
					index = index + moduleDivision;
					if(x > 0){
						index = 0;
					}
					if(maxSlideIndex > 0 && index > maxSlideIndex){
						index = maxSlideIndex;
					}
					
					TweenLite.to(self,0.3,{x:-index*game.stageWidth, onComplete:function():void{
						self.dispatchEvent(new ScrollEvent(ScrollEvent.ScrollSettled,{'index':index}));
					}});
				},100);
				
					//						mTouching = false;
					//					}
//				touchEndTimeout = setTimeout(function():void{
//					mTouching = true;
//					
//					//trace(getClosestX());
//					TweenLite.to(this,0.3,{x:getClosestX(), onComlete:function():void{
//						mTouching = false;
//					}
//					});
//				},300);
			}
		}
		
		private function clearTween():void
		{
			clearTimeout(touchEndTimeout);
			TweenLite.killTweensOf(this);
			mTouching = false;
		}
		
		private function getClosestX():Number
		{
			var currentX:Number = x;
			var moduloLeft:Number = x % game.stageWidth;
			
			var slideIndex:int = Math.floor(x / game.stageWidth);
			//trace('slideIndex: '+slideIndex);
			
			var moduleDivision:Number = Math.round(moduloLeft / game.stageWidth);
			slideIndex = slideIndex + moduleDivision;
			
			return slideIndex * game.stageWidth;
		}
		
	}
}