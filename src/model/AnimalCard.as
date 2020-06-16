package model
{
	public class AnimalCard
	{
		private var _name:String;
		private var _value:Number;
		private var _prefix:String;

		private var _nameTranslations:Array;
		public function AnimalCard(name:String, value:Number, translationNames:Array, prefix:String = "de")
		{
			_name = name;
			_value = value;
			_prefix = prefix;
			_nameTranslations = translationNames;
		}
		public function getAnimalName():String{
			return _name;
		}
		public function getAnimalValue():Number{
			return _value;
		}
		public function get value():Number{
			return _value;
		}
		public function get name():String{
			return _name;
		}
		public function get dutchNameWithPrefix():String{
			return _prefix+" "+(_nameTranslations[0] as String);
		}
		
	}
}