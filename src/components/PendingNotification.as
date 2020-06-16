package components
{
	import model.Player;

	public class PendingNotification
	{
		public var message:String;
		public var targetPlayer:Player;
		public var autoHide:Boolean;
		public function PendingNotification(r_targetPlayer:Player,r_message:String, r_autoHide:Boolean = true)
		{
			message = r_message;
			targetPlayer = r_targetPlayer;
			autoHide = r_autoHide;
		}
	}
}