/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IBigObject
import engine.maps.interfaces.IMapBlockState
import engine.maps.interfaces.IMapObject
import engine.maps.interfaces.IMapObjectType
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullMapObject
import engine.model.explosionss.ExplosionType

public class BlockUnderBigObject implements IMapBlockState {

    private var _explodesAndStopsExplosion:Boolean;
    private var _canGoThrough:Boolean;
    private var _canSetBomb:Boolean;
    private var _canExplosionGoThrough:Boolean;
    private var _typeAfterObjectDestroyed:MapBlockType;
    private var _objectAfterObjectDestroyed:IMapObjectType;

    private var objectUnder:IBigObject;
    private var _explodes:Boolean;

    public function explodesAndStopsExplosion():Boolean {
        return _explodesAndStopsExplosion;
    }

    public function canGoThrough():Boolean {
        return _canGoThrough;
    }

    public function canSetBomb():Boolean {
        return _canSetBomb;
    }

    public function canExplosionGoThrough():Boolean {
        return _canExplosionGoThrough;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false;
    }

    public function explode(expl:IExplosion):void {
        if (_explodes)
            objectUnder.explode(expl);
    }

    public function get type():MapBlockType {
        return MapBlockType.UNDER_BIG_OBJECT;
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.UNDER_BIG_OBJECT;
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function get hiddenObject():IMapObject {
        return NullMapObject.getInstance();
    }

    public function set hiddenObject(value:IMapObject):void {

    }

    public function BlockUnderBigObject(explodesAndStopsExplosion:Boolean, canGoThrough:Boolean, canSetBomb:Boolean, canExplosionGoThrough:Boolean, typeAfterObjectDestroyed:MapBlockType, objectAfterObjectDestroyed:IMapObjectType, explodes:Boolean, objectUnder:IBigObject) {
        _explodesAndStopsExplosion = explodesAndStopsExplosion;
        _canGoThrough = canGoThrough;
        _canSetBomb = canSetBomb;
        _canExplosionGoThrough = canExplosionGoThrough;
        _explodes = explodes;
        _typeAfterObjectDestroyed = typeAfterObjectDestroyed;
        _objectAfterObjectDestroyed = objectAfterObjectDestroyed;
        this.objectUnder = objectUnder;
    }

    public function get typeAfterObjectDestroyed():MapBlockType {
        return _typeAfterObjectDestroyed;
    }

    public function get objectAfterObjectDestroyed():IMapObjectType {
        return _objectAfterObjectDestroyed;
    }

}
}
