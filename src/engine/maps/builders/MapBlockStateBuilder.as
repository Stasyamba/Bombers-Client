/*
 * Copyright (c) 2010. 
 * Pavkin Vladimir
 */

package engine.maps.builders {
import engine.maps.bigObjects.BigObjectBase
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapBlocks.NullMapBlock
import engine.maps.mapBlocks.mapBlockStates.BlockUnderBigObject
import engine.maps.mapBlocks.mapBlockStates.BoxBlock
import engine.maps.mapBlocks.mapBlockStates.DeathWallBlock
import engine.maps.mapBlocks.mapBlockStates.ElectroBlock
import engine.maps.mapBlocks.mapBlockStates.FireBlock
import engine.maps.mapBlocks.mapBlockStates.FragileWallBlock
import engine.maps.mapBlocks.mapBlockStates.FreeBlock
import engine.maps.mapBlocks.mapBlockStates.GlueBlock
import engine.maps.mapBlocks.mapBlockStates.IceBlock
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
            case MapBlockType.FIRE:
                return new FireBlock()
            case MapBlockType.ICE:
                return new IceBlock()
            case MapBlockType.GLUE:
                return new GlueBlock()
            case MapBlockType.ELECTRO_HOR:
                return new ElectroBlock(true)
            case MapBlockType.ELECTRO_VERT:
                return new ElectroBlock(false)
            case MapBlockType.NULL:
                return NullMapBlock.getInstance();
        }
        throw new ArgumentError("Invalid Argument");
    }

    public function MapBlockStateBuilder() {
    }

    public function makeUnderObject(explodesAndStopsExplosion:Boolean, canGoThrough:Boolean, canExplosionGoThrough:Boolean, canSetBomb:Boolean, stateAfterObjectDestroyed:MapBlockType, objectAfterObjectDestroyed:IDynObjectType, explodes:Boolean, under:BigObjectBase):IMapBlockState {
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