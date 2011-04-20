/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.mapBlocks.MapBlockType

public class MapBlockAmount {

    private var _type:MapBlockType;
    private var _amount:int;

    public function get type():MapBlockType {
        return _type;
    }

    public function get amount():int {
        return _amount;
    }

    public function MapBlockAmount(type:MapBlockType, count:int) {
        _type = type;
        _amount = count;
    }
}
}
