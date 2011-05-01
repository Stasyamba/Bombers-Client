/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.special {
import engine.maps.interfaces.IDynObjectType

import loading.LoaderUtils

public class SpecialObjectType implements IDynObjectType {

    public static const VIOLET_MUSHROOM:SpecialObjectType = new SpecialObjectType(1011, "VIOLET_MUSHROOM");
    public static const YELLOW_MUSHROOM:SpecialObjectType = new SpecialObjectType(1012, "YELLOW_MUSHROOM");
    public static const RED_MUSHROOM:SpecialObjectType = new SpecialObjectType(1013, "RED_MUSHROOM");


    private var _value:int;
    private var _key:String;

    public function SpecialObjectType(value:int, key:String) {
        _value = value
        _key = key
    }

    public static function byValue(value:int):SpecialObjectType {
        switch (value) {
            case VIOLET_MUSHROOM.value:
                return VIOLET_MUSHROOM;
            case YELLOW_MUSHROOM.value:
                return YELLOW_MUSHROOM;
            case RED_MUSHROOM.value:
                return RED_MUSHROOM;
        }
        throw new ArgumentError("wrong special object type value " + int)
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

    public function get stringId():String {
        return LoaderUtils.stringId(value)
    }

}
}
