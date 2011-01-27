/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.single.goals {
import engine.maps.interfaces.IMapObjectType

public class MapObjectAmount {

    private var _type:IMapObjectType;
    private var _amount:int;

    public function get type():IMapObjectType {
        return _type;
    }

    public function get amount():int {
        return _amount;
    }

    public function MapObjectAmount(type:IMapObjectType, count:int) {
        _type = type;
        _amount = count;
    }
}
}
