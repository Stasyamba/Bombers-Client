/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.maps.interfaces.IMapObjectType

public class BonusType implements IMapObjectType {

    public static const ADD_BOMB:BonusType = new BonusType(101, "ADD_BOMB");
    public static const ADD_BOMB_POWER:BonusType = new BonusType(102, "ADD_BOMB_POWER");
    public static const ADD_SPEED:BonusType = new BonusType(103, "ADD_SPEED");
    public static const HEAL:BonusType = new BonusType(104, "HEAL");

    public static const EXPERIENCE:BonusType = new BonusType(105, "EXPERIENCE")
    public static const RESOURCE:BonusType = new BonusType(106, "RESOURCE")


    private var _value:int;
    private var _key:String;

    public static function byValue(value:int):BonusType {
        switch (value) {
            case 1:
                return ADD_BOMB;
            case 2:
                return ADD_BOMB_POWER;
            case 3:
                return ADD_SPEED;
            case 4:
                return HEAL;
            case 11:
                return EXPERIENCE;
            case 12:
                return RESOURCE;
        }
        throw new ArgumentError("wrong bonus type value")
    }

    public function BonusType(value:int, key:String) {
        _value = value;
        _key = key;
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function get waitToAdd():Number {
        return 0
    }
}
}