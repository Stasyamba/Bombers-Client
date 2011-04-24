/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.EngineContext
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapBlocks.mapBlockStates.BlockUnderBigObject
import engine.maps.mapObjects.DynObjectType

import greensock.TweenMax

import org.osflash.signals.Signal

public class SimpleBigObject extends BigObjectBase {

    private var _life:int

    private var _isExplodingNow:Boolean;
    private var _explosionStopped:Signal = new Signal();
    private var _explosionStarted:Signal = new Signal();
    private var _destroyed:Signal = new Signal();

    public function SimpleBigObject(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder, life:int) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder)
        _life = life
    }

    public function get life():int {
        return _life;
    }

    public function get isDestroyed():Boolean {
        return life <= 0;
    }

    public function explode(expl:IExplosion):void {
        if (isDestroyed) return;
        if (!_isExplodingNow) {
            if (expl.damage >= life)
                destroy()
            else {
                _life -= expl.damage;
                startExplosion();
                TweenMax.delayedCall(3, function():void {
                    stopExplosion();
                })
            }
        }
    }

    private function stopExplosion():void {
        _isExplodingNow = false;
        explosionStopped.dispatch()
    }

    private function startExplosion():void {
        _isExplodingNow = true;
        explosionStarted.dispatch()
    }

    public function destroy():void {
        _life = 0;
        for each (var block:IMapBlock in _blocks) {
            if (block.type == MapBlockType.UNDER_BIG_OBJECT) {
                var oldState:BlockUnderBigObject = block.state as BlockUnderBigObject;
                block.setState(_mapBlockStateBuilder.make(oldState.typeAfterObjectDestroyed));

                if (oldState.objectAfterObjectDestroyed != DynObjectType.NULL)
                    EngineContext.objectAdded.dispatch(block.x, block.y, oldState.objectAfterObjectDestroyed)
            }
        }
        destroyed.dispatch();
    }

    public function get explosionStopped():Signal {
        return _explosionStopped;
    }

    public function get explosionStarted():Signal {
        return _explosionStarted;
    }

    public function get destroyed():Signal {
        return _destroyed;
    }
}
}
