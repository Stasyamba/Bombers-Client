package components.common.items.categories {
public class ItemCategory {
    public static const WEAPON:ItemCategory = new ItemCategory(0, "WEAPON");
    public static const AURA:ItemCategory = new ItemCategory(1, "AURA");
    public static const METAMORPH:ItemCategory = new ItemCategory(2, "METAMORPH");
    public static const QUEST_ITEM:ItemCategory = new ItemCategory(3, "QUEST_ITEM");

	public static const PART: ItemCategory = new ItemCategory(4, "PART");
	
	
    private var _value:int;
    private var _name:String;

    public function ItemCategory(value:int, name:String) {
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