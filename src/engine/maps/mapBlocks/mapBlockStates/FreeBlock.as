/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.explosionss.interfaces.IExplosion
import engine.maps.mapObjects.NullDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType

public class FreeBlock implements IMapBlockState {

    public function FreeBlock() {
    }

    public function canGoThrough():Boolean {
        return true;
    }

    public function canSetBomb():Boolean {
        return true;
    }

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.FREE;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function explode(expl:IExplosion):void {
        //do nothing: nothing to explode
    }

    public function get type():MapBlockType {
        return MapBlockType.FREE;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return true;
    }

    public function get canShowObjects():Boolean {
        return true;
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {

    }
}
}