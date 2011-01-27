package components.common.items.categories {
public class AuraCategory {
    public static const FIRE:AuraCategory = new AuraCategory(0, "FIRE");
    public static const COLD:AuraCategory = new AuraCategory(1, "COLD");


    private var _value:int;
    private var _name:String;

    public function AuraCategory(value:int, name:String) {
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