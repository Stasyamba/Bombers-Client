/*
 * Copyright (c) 2010. 
 * Pavkin Vladimir
 */

package engine.maps.builders {
import engine.maps.interfaces.IBigObject
import engine.maps.interfaces.IMapBlockState
import engine.maps.interfaces.IMapObjectType
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapBlocks.NullMapBlock
import engine.maps.mapBlocks.mapBlockStates.BlockUnderBigObject
import engine.maps.mapBlocks.mapBlockStates.BoxBlock
import engine.maps.mapBlocks.mapBlockStates.DeathWallBlock
import engine.maps.mapBlocks.mapBlockStates.FragileWallBlock
import engine.maps.mapBlocks.mapBlockStates.FreeBlock
import engine.maps.mapBlocks.mapBlockStates.WallBlock

public class MapBlockStateBuilder {

    public function make(typeCode:MapBlockType, lifePoints:int = 1):IMapBlockState {
        switch (typeCode) {
            case MapBlockType.FREE:
                return new FreeBlock();
            case MapBlockType.BOX:
                return new BoxBlock();
            case MapBlockType.WALL:
                return new WallBlock();
            case MapBlockType.FRAGILE_WALL:
                return new FragileWallBlock(lifePoints);
            case MapBlockType.DEATH_WALL:
                return new DeathWallBlock();
            case MapBlockType.NULL:
                return NullMapBlock.getInstance();
        }
        throw new ArgumentError("Invalid Argument");
    }

    public function MapBlockStateBuilder() {
    }

    public function makeUnderObject(explodesAndStopsExplosion:Boolean, canGoThrough:Boolean, canExplosionGoThrough:Boolean, canSetBomb:Boolean, stateAfterObjectDestroyed:MapBlockType, objectAfterObjectDestroyed:IMapObjectType, explodes:Boolean, under:IBigObject):IMapBlockState {
        return new BlockUnderBigObject(explodesAndStopsExplosion,
                canGoThrough,
                canSetBomb,
                canExplosionGoThrough,
                stateAfterObjectDestroyed,
                objectAfterObjectDestroyed,
                explodes,
                under);
    }
}
}