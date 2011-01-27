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

public class WallBlock implements IMapBlockState {
    public function WallBlock() {
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function get type():MapBlockType {
        return MapBlockType.WALL;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function canSetBomb():Boolean {
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        return false;
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        if (expl.type == ExplosionType.ATOM)
            return MapBlockType.FREE;
        return MapBlockType.WALL;
    }

    public function explode(expl:IExplosion):void {
        //do nothing, this is a wall dude
        // atom explosion makes it free so do nothing either
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return (explType == ExplosionType.ATOM)
    }

    public function get hiddenObject():IMapObject {
        return NullMapObject.getInstance();
    }

    public function set hiddenObject(value:IMapObject):void {
    }
}
}