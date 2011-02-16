package components.common.bombers {
import components.common.items.ItemType

public class BomberType {

    public static const FURY_JOE:BomberType = new BomberType(0, "FURY_JOE", ItemType.BASE_BOMB,1,1,100,3);
    public static const R2D3:BomberType = new BomberType(1, "R2D3", ItemType.BASE_BOMB,1,1,100,3);

    private var _value:int;
    private var _name:String;
    private var _baseBomb:ItemType;

    //game skills
    private var _bombCount:int;
    private var _bombPower:int;
    private var _speed:Number;
    private var _startLife:int


    public function BomberType(value:int, name:String, baseBomb:ItemType, bombCount:int, bombPower:int, speed:Number, startLife:int) {
        _value = value
        _name = name
        _baseBomb = baseBomb
        this._bombCount = bombCount
        this._bombPower = bombPower
        this._speed = speed
        this._startLife = startLife
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

    public function get bombCount():int {
        return _bombCount
    }

    public function get bombPower():int {
        return _bombPower
    }

    public function get speed():Number {
        return _speed
    }

    public function get startLife():int {
        return _startLife
    }

    public static function getViewSpeed(type:BomberType,speed:Number):int {
       return int(Math.round((Math.log(speed) - Math.log(type.speed))/Math.log(1.1))) + 1
    }
}
}