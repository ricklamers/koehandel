package events
{
	import starling.events.Event;
	
	public class ScrollEvent extends Event
	{	
		public static const ScrollSettled:String = "scrollSettled";

		public var values:Object;
		
		public function ScrollEvent(type:String, values:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.values = values;
			super(type, bubbles, cancelable);
		}
	}
}