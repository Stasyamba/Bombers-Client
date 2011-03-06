package components.common.items.collections
{
	public class ItemCollectionType
	{
		public static const AURA_WARM_NIGHT:ItemCollectionType = new ItemCollectionType(0, "AURA_WARM_NIGHT");
		
		private var _value:int;
		private var _name:String;
		
		public function ItemCollectionType(value:int, name:String) {
			_value = value;
			_name = name;
		}
		
		public function get value():int {
			return _value;
		}
		
		public function get name():String {
			return _name;
		}
	}
}