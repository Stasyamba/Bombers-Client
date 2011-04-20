/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.interfaces.IDynObjectType

public class MapObjectAmount {

    private var _type:IDynObjectType;
    private var _amount:int;

    public function get type():IDynObjectType {
        return _type;
    }

    public function get amount():int {
        return _amount;
    }

    public function MapObjectAmount(type:IDynObjectType, count:int) {
        _type = type;
        _amount = count;
    }
}
}
