/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

public class BoxBlock implements IMapBlockState {

    private var _hiddenObject:IDynObject = NullDynObject.getInstance();

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

    public function canGoThrough(creature:CreatureBase = null):Boolean {
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

    public function get hiddenObject():IDynObject {
        return _hiddenObject;
    }

    public function set hiddenObject(value:IDynObject):void {
        _hiddenObject = value;
    }

    public function get blinks():Boolean {
        return true
    }

}
}