/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.mines {
import engine.maps.interfaces.IDynObjectType

import loading.LoaderUtils

public class MineType implements IDynObjectType {
    public static const REGULAR:MineType = new MineType(41, "REGULAR");

    private var _key:String;
    private var _value:int;

    public function MineType(value:int, key:String) {
        _key = key
        _value = value
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key
    }

    public function get waitToAdd():Number {
        return 2
    }

    public function get stringId():String {
        return LoaderUtils.stringId(value)
    }
}
}
