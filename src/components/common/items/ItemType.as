package components.common.items {
public class ItemType {
    public static const QUEST_ITEM_CANARY:ItemType = new ItemType(0, "QUEST_ITEM_CANARY");
    public static const QUEST_ITEM_SNOWBOOTS:ItemType = new ItemType(1, "QUEST_ITEM_SNOWBOOTS");
    public static const NUCLEAR_BOMB:ItemType = new ItemType(2, "WEAPON_ITEM_NUCLEAR_BOMB");
    public static const AURA_FIRE:ItemType = new ItemType(3, "FIRE_AURA");

    public static const BASE_BOMB:ItemType = new ItemType(4, "BASE_BOMB");

    public static const HAMELION_POISON:ItemType = new ItemType(5, "HAMELION_POISEN");
    public static const X_RAY_BOMB:ItemType = new ItemType(6, "X_RAY_BOMB");
    public static const MINA_BOMB:ItemType = new ItemType(7, "MINA_BOMB");

    private var _value:int;
    private var _name:String;

    public function ItemType(value:int, name:String) {
        _value = value;
        _name = name;
    }


    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "value: " + _value.toString() + " name: " + _name.toString();
    }

}
}