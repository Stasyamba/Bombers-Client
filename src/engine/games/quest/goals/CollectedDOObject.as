/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.interfaces.IDynObjectType

public class CollectedDOObject {

    private var _type:IDynObjectType
    private var _x:int
    private var _y:int

    public function CollectedDOObject(objType:IDynObjectType, x:int, y:int) {
        _type = objType
        _x = x
        _y = y
    }


    public function get type():IDynObjectType {
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
