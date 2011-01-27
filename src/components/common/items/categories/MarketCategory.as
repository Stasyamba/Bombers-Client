package components.common.items.categories {
public class MarketCategory {
    public static const BOMBS_AND_POISONS:MarketCategory = new MarketCategory(0, "BOMBS_AND_POISONS");
    public static const METAMORPHS:MarketCategory = new MarketCategory(1, "METAMORPHS");
    public static const VARIOUS:MarketCategory = new MarketCategory(2, "VARIOUS");

    private var _value:int;
    private var _name:String;

    public function MarketCategory(value:int, name:String) {
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