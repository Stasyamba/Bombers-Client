package components.common.base.access.rules {
public class AccessRuleType {

    public static const BETA_RULE:AccessRuleType = new AccessRuleType(0, "BETA_ACCESS_RULE");
    public static const LEVEL_RULE:AccessRuleType = new AccessRuleType(1, "LEVEL_ACCESS_RULE");
    public static const PRICE_RULE:AccessRuleType = new AccessRuleType(2, "PRICE_ACCESS_RULE");
    public static const OPENED_LOCATIONS_RULE:AccessRuleType = new AccessRuleType(3, "OPENED_LOCATIONS_ACCESS_RULE");
    public static const ITEM_RULE:AccessRuleType = new AccessRuleType(4, "ITEM_ACCESS_RULE");

    private var _value:int;
    private var _name:String;

    public function AccessRuleType(value:int, name:String) {
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