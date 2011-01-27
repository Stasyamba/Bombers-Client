package components.common.resources {

public class ResourceType {

    public static const GOLD:ResourceType = new ResourceType(0, "GOLD");
    public static const CRYSTALS:ResourceType = new ResourceType(1, "CRYSTALS");
    public static const ADAMANT:ResourceType = new ResourceType(2, "ADAMANT");
    public static const ANTIMATTER:ResourceType = new ResourceType(3, "ANTIMATTER");

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
