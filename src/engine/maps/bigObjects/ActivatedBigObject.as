/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder

import org.osflash.signals.Signal

public class ActivatedBigObject extends BigObjectBase {

    private var _isActivated:Boolean = false
    private var _activated:Signal = new Signal()

    public function ActivatedBigObject(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder)
    }

    public function activate():void {
        _isActivated = true;
        onActivated()
    }

    private function onActivated():void {
        _activated.dispatch()
    }

    public function get isActivated():Boolean {
        return _isActivated
    }

    public function get activated():Signal {
        return _activated
    }
}
}
