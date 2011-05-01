/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.mapBlocks.MapBlockType

public class DestroyedMapBlockObject {

    private var _type:MapBlockType
    private var _x:int
    private var _y:int

    public function DestroyedMapBlockObject(type:MapBlockType, x:int, y:int) {
        _type = type
        _x = x
        _y = y
    }

    public function get type():MapBlockType {
        return _type
    }

    public function get x():int {
        return _x
    }

    public function get y():int {
        return _y
    }


}
}
