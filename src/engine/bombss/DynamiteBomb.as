/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.explosionss.ExplosionType

public class DynamiteBomb extends BombBase implements ITimeActivatableDynObject {
    private static const EXPLODE_TIME:int = 2000;

    public function DynamiteBomb(explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(explosionsBuilder, block, player);
        _explodeTime = EXPLODE_TIME;
    }

    public override function get type():IDynObjectType {
        return BombType.DYNAMITE;
    }

    override protected function getExplosion():IExplosion {
        return _explosionsBuilder.make(ExplosionType.DYNAMITE, block.x, block.y)
    }
}
}
