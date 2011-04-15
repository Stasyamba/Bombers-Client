/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IActiveMapBlockState
import engine.maps.interfaces.IDynObject
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

public class GlueBlock implements IActiveMapBlockState {
    public function GlueBlock() {
    }

    public function activateOn(bomber:IBomber):void {
        bomber.setSpeed(20)
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function canGoThrough():Boolean {
        return true
    }

    public function canSetBomb():Boolean {
        return true
    }

    public function canExplosionGoThrough():Boolean {
        return true
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false
    }

    public function explode(expl:IExplosion):void {
    }

    public function get type():MapBlockType {
        return MapBlockType.GLUE
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.GLUE
    }

    public function get canShowObjects():Boolean {
        return true
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {
    }
}
}
