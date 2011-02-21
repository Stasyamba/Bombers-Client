package components.common.items {
public class ItemType {
    public static const QUEST_ITEM_CANARY:ItemType = new ItemType(1001, "QUEST_ITEM_CANARY");
    public static const QUEST_ITEM_SNOWBOOTS:ItemType = new ItemType(1002, "QUEST_ITEM_SNOWBOOTS");
    public static const NUCLEAR_BOMB:ItemType = new ItemType(01, "WEAPON_ITEM_NUCLEAR_BOMB");
    public static const AURA_FIRE:ItemType = new ItemType(61, "FIRE_AURA");

    public static const BASE_BOMB:ItemType = new ItemType(0, "BASE_BOMB");

    public static const HAMELEON_POISON:ItemType = new ItemType(21, "HAMELEON_POISON");
    public static const X_RAY_BOMB:ItemType = new ItemType(-1, "X_RAY_BOMB");
    public static const MINA_BOMB:ItemType = new ItemType(41, "MINA_BOMB");
    public static const BOX_BOMB:ItemType = new ItemType(02, "BOX_BOMB")
    public static const DINAMIT_BOMB:ItemType = new ItemType(03, "DINAMIT_BOMB");
	public static const SMOKE_BOMB:ItemType = new ItemType(04, "SMOKE_BOMB");

	
	public static const HEALTH_PACK_POISON:ItemType = new ItemType(22, "HEALTH_PACK_POISON");
	public static const HEALTH_PACK_ADVANCED_POISON:ItemType = new ItemType(23, "HEALTH_PACK_ADVANCED_POISON");

	
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

    public static function byValue(value:int):ItemType {
        switch (value) {
            case QUEST_ITEM_CANARY.value:
                return QUEST_ITEM_CANARY
            case QUEST_ITEM_SNOWBOOTS.value:
                return QUEST_ITEM_SNOWBOOTS
            case NUCLEAR_BOMB.value:
                return NUCLEAR_BOMB
            case AURA_FIRE.value:
                return AURA_FIRE
            case BASE_BOMB.value:
                return BASE_BOMB
            case HAMELEON_POISON.value:
                return HAMELEON_POISON
            case X_RAY_BOMB.value:
                return X_RAY_BOMB
            case MINA_BOMB.value:
                return MINA_BOMB
            case DINAMIT_BOMB.value:
                return DINAMIT_BOMB
            case BOX_BOMB.value:
                return BOX_BOMB
            case SMOKE_BOMB.value:
                return SMOKE_BOMB
            case HEALTH_PACK_POISON.value:
                return HEALTH_PACK_POISON
            case HEALTH_PACK_ADVANCED_POISON.value:
                return HEALTH_PACK_ADVANCED_POISON
        }
        throw new ArgumentError("no ItemType found with value = " + value);
    }
}
}