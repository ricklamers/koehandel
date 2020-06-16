package model
{
	public class MoneyCard
	{
		private var value:Number;
		public function MoneyCard(r_value:Number)
		{
			value = r_value;	
		}
		
		public function get getValue():Number{
			return value;
		}
	}
}