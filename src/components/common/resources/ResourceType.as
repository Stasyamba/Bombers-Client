package components.common.resources {

public class ResourceType {

    public static const GOLD:ResourceType = new ResourceType(00, "GOLD");
    public static const CRYSTALS:ResourceType = new ResourceType(01, "CRYSTALS");
    public static const ADAMANT:ResourceType = new ResourceType(02, "ADAMANT");
    public static const ANTIMATTER:ResourceType = new ResourceType(03, "ANTIMATTER");
    public static const ENERGY:ResourceType = new ResourceType(04, "ENERGY");

    private var _value:int;
    private var _name:String;

    public function ResourceType(value:int, name:String) {
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
