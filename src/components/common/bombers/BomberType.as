package components.common.bombers {
import components.common.items.ItemType

public class BomberType {

    public static const FURY_JOE:BomberType = new BomberType(0, "FURY_JOE",ItemType.BASE_BOMB);
    public static const R2D3:BomberType = new BomberType(1, "R2D3",ItemType.BASE_BOMB);

    private var _value:int;
    private var _name:String;
    private var _baseBomb:ItemType;

    public function BomberType(value:int, name:String, baseBomb:ItemType) {
        _value = value
        _name = name
        _baseBomb = baseBomb
    }

    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function get baseBomb():ItemType {
        return _baseBomb
    }

    public static function byValue(value:int):BomberType {
        switch (value) {
            case FURY_JOE.value:
                return FURY_JOE
            case R2D3.value:
                return R2D3
        }
        throw new ArgumentError("no BomberType found with value = " + value);
    }
}
}