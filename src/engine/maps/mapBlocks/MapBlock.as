/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks {
import engine.EngineContext
import engine.explosionss.interfaces.IExplosion
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

import mx.controls.Alert

import org.osflash.signals.Signal

//builders are injected after creation
public class MapBlock extends MapBlockBase implements IMapBlock {


    private var _mapBlockStateBuilder:MapBlockStateBuilder;
    private var _mapObjectBuilder:DynObjectBuilder;


    private var _object:IDynObject;

    private var _isExplodingNow:Boolean = false;

    private var _objectCollected:Signal = new Signal(Boolean);

    private var _explodedBy:ExplosionType;
    private var _hasExplosionPrint:Boolean = false;
    private var _destroyed:Signal = new Signal(int, int, MapBlockType);
    private var _objectSet:Signal = new Signal(IDynObject);

    public function get isExplodingNow():Boolean {
        return _isExplodingNow;
    }


    public function canSetBomb():Boolean {
        return object.type == DynObjectType.NULL && state.canSetBomb();
    }

    public function canGoThrough():Boolean {
        if (object.canGoThrough())
            return state.canGoThrough();
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        if (!object.canExplosionGoThrough())
            return false;
        return state.canExplosionGoThrough();
    }

    public function explodesAndStopsExplosion():Boolean {
        if (object.explodesAndStopsExplosion())
            return true;
        return state.explodesAndStopsExplosion();
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return state.canHaveExplosionPrint(explType);
    }

    private function checkExplosionPrint(expl:IExplosion):void {
        if (!expl.type.printsPrints)
            return;
        if (expl.type.printsEverywhere || (expl.centerX == x && expl.centerY == y)) {
            if (state.canHaveExplosionPrint(expl.type)) {
                _hasExplosionPrint = true;
                _explodedBy = expl.type
            }
        }
    }

    public function explode(expl:IExplosion):void {

        checkExplosionPrint(expl);

        if (expl.type == ExplosionType.SMOKE) {
            EngineContext.smokeAdded.dispatch(x, y)
            return
        }

        if (expl.type == ExplosionType.BOX) {
            setState(_mapBlockStateBuilder.make(MapBlockType.BOX));
            return;
        }

        if (isExplodingNow) return;
        if (_state.stateAfterExplosion(expl) != _state.type) {
            explosionStopped.addOnce(function():void {
                if (_state.stateAfterExplosion(expl) == MapBlockType.FREE) {
                    _object = _state.hiddenObject;
                    _destroyed.dispatch(x, y, _state.type)
                }
                setState(_mapBlockStateBuilder.make(_state.stateAfterExplosion(expl)));
            });
        }
        else
            state.explode(expl);

        _isExplodingNow = true;
        explosionStarted.dispatch();
    }

    public function stopExplosion():void {
        _isExplodingNow = false;
        explosionStopped.dispatch();
        viewUpdated.dispatch();
    }

    public function setState(state:IMapBlockState):void {
        _state = state;
        viewUpdated.dispatch();
    }


    /*
     * use mapblock builder instead
     * */
    function MapBlock(x:int, y:int, block:IMapBlockState, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder) {
        _x = x;
        _y = y;
        _state = block;
        _mapBlockStateBuilder = mapBlockStateBuilder;
        _mapObjectBuilder = mapObjectBuilder;

        _object = NullDynObject.getInstance();
    }

    public function collectObject(byMe:Boolean):void {
        objectCollected.dispatch(byMe)
        viewUpdated.dispatch();
        _object = NullDynObject.getInstance();
    }

    public function setObject(object:IDynObject):void {
        if (object == null) {
            Alert.show("NULL OBJECT")
            return
        }
        objectSet.dispatch(object);
        if (state.canShowObjects) {
            _object = object;
            viewUpdated.dispatch();
        } else {
            state.hiddenObject = object;
        }
    }

    public function setDieWall():void {
        _state = _mapBlockStateBuilder.make(MapBlockType.DEATH_WALL)
        viewUpdated.dispatch();
    }

    //getters
    public function get hasExplosionPrint():Boolean {
        return _explodedBy != null;
    }


    public function get object():IDynObject {
        return _object;
    }


    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return state.stateAfterExplosion(expl);
    }

    public function get objectCollected():Signal {
        return _objectCollected;
    }

    public function get objectSet():Signal {
        return _objectSet;
    }

    public function get hiddenObject():IDynObject {
        return state.hiddenObject;
    }

    public function set hiddenObject(value:IDynObject):void {
        state.hiddenObject = value;
    }

    public function get canShowObjects():Boolean {
        return state.canShowObjects;
    }

    public function get explodedBy():ExplosionType {
        return _explodedBy;
    }

    public function get destroyed():Signal {
        return _destroyed;
    }

}
}