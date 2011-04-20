/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.model.explosionss.ExplosionType

public class ExplosionPoint {

    private var _type:ExplosionPointType;
    private var _x:int;
    private var _y:int;
    // array of ExplosionPointLayerObject
    public var layers : Array = new Array()

    public function ExplosionPoint(x:int, y:int, type:ExplosionPointType,owner:IBomber = null,ep:ExplosionType = null) {
        _x = x;
        _y = y;
        _type = type;
        if(owner!=null)
            layers.push(new ExplosionPointLayerObject(owner,ep))
    }

    public function get type():ExplosionPointType {
        return _type;
    }

    public function set type(value:ExplosionPointType):void {
        _type = value;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }
}
}