package components.common.bombers {
public class BomberType {

    public static const FURY_JOE:BomberType = new BomberType(0, "FURY_JOE");
    public static const R2D3:BomberType = new BomberType(1, "R2D3");

    private var _value:int;
    private var _name:String;

    public function BomberType(value:int, name:String) {
        _value = value;
        _name = name;
    }


    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public static function byValue(value:int):BomberType {
        switch(value){
            case FURY_JOE.value:
                return FURY_JOE
            case R2D3.value:
                return R2D3
        }
        throw new ArgumentError("no BomberType found with value = " + value);
    }
}
}