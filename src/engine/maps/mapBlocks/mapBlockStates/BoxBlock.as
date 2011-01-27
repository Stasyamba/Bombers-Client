/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlockState
import engine.maps.interfaces.IMapObject
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullMapObject
import engine.model.explosionss.ExplosionType

public class BoxBlock implements IMapBlockState {

    private var _hiddenObject:IMapObject = NullMapObject.getInstance();

    public function BoxBlock() {
    }

    public function explodesAndStopsExplosion():Boolean {
        return true;
    }

    public function explode(expl:IExplosion):void {
        // do nothing 'cause type will change
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.FREE;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function canSetBomb():Boolean {
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function get type():MapBlockType {
        return MapBlockType.BOX;
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return true;
    }

    public function get hiddenObject():IMapObject {
        return _hiddenObject;
    }

    public function set hiddenObject(value:IMapObject):void {
        _hiddenObject = value;
    }
}
}