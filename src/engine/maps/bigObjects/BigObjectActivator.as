/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder

public class BigObjectActivator extends BigObjectBase {

    private var _target:ActivatedBigObject
    private var _keys:Array = new Array()

    private var _activated:Boolean

    public function BigObjectActivator(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder)
        for (var y:int = 0; y < _height; y++) {
            for (var x:int = 0; x < _width; x++) {
                setKey(x, y, false)
            }
        }
    }

    private function setKey(x:int, y:int, val:Boolean):void {
        _keys[getIndex(x, y)] = val
    }

    private function getKey(x:int, y:int):Boolean {
        return _keys[getIndex(x, y)]
    }

    private function getIndex(x:int, y:int):int {
        return y * _width + x
    }

    public function activateKey(x:int, y:int):void {
        if (_activated)
            return
        setKey(x, y, true)
        if (activated) {
            _target.activate()
        }
    }

    private function get activated():Boolean {
        for (var y:int = 0; y < _height; y++) {
            for (var x:int = 0; x < _width; x++) {
                if (!getKey(x, y))
                    return false
            }
        }
        return _activated = true
    }

    public function setTarget(bo:ActivatedBigObject):void {
        _target = bo
    }
}
}
