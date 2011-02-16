/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.maps.interfaces.IDynObjectType

public class BombType implements IDynObjectType {

    public static const NULL:BombType = new BombType(-1, "NULL", false);
    public static const REGULAR:BombType = new BombType(00, "REGULAR", true);
    public static const ATOM:BombType = new BombType(01, "ATOM", false);
    public static const BOX:BombType = new BombType(02, "BOX", false);
    public static const DYNAMITE:BombType = new BombType(03, "DYNAMITE", false);

    private var _value:int;
    private var _key:String;
    private var _needGlow:Boolean;

    function BombType(value:int, key:String, needGlow:Boolean) {
        _value = value;
        _key = key;
        _needGlow = needGlow;
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function get needGlow():Boolean {
        return _needGlow;
    }

    public function get waitToAdd():int {
        return 0
    }

    public static function byValue(value:int):BombType {
        switch (value) {
            case NULL.value:
                return NULL;
            case REGULAR.value:
                return REGULAR;
            case ATOM.value:
                return ATOM;
            case BOX.value:
                return BOX;
            case DYNAMITE.value:
                return DYNAMITE;
        }
        throw new ArgumentError("wrong bombType value");
    }
}
}