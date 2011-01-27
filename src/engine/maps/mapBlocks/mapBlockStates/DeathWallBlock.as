/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.explosionss.interfaces.IExplosion
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType

public class DeathWallBlock extends WallBlock {
    public function DeathWallBlock() {
    }

    override public function get type():MapBlockType {
        return MapBlockType.DEATH_WALL;
    }

    override public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.DEATH_WALL;
    }

    override public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false;
    }
}
}
