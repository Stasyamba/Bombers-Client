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

public class FragileWallBlock implements IMapBlockState {

    public function FragileWallBlock(lifePoints:int = 1) {
        this.lifePoints = lifePoints;
    }

    public var lifePoints:int;

    private var _hiddenObject:IDynObject = NullDynObject.getInstance();

    public function canSetBomb():Boolean {
        return false;
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return lifePoints > 1 ? MapBlockType.FRAGILE_WALL : MapBlockType.FREE;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function explodesAndStopsExplosion():Boolean {
        return true;
    }

    public function explode(expl:IExplosion):void {
        throw new Error("Implement fragile walls exploding")
    }

    public function get type():MapBlockType {
        return MapBlockType.FRAGILE_WALL;
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return lifePoints > 1;
    }

    public function get hiddenObject():IDynObject {
        return _hiddenObject;
    }

    public function set hiddenObject(value:IDynObject):void {
        _hiddenObject = value;
    }
}
}