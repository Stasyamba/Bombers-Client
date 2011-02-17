/*
 * Copyright (c) 2010.
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

public class AtomBomb extends BombBase implements ITimeActivatableDynObject {

    private static const EXPLODE_TIME:int = 3000;

    public function AtomBomb(explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(explosionsBuilder, block, player);
        _explodeTime = EXPLODE_TIME;
    }

    public override function get type():IDynObjectType {
        return BombType.ATOM;
    }

    override protected function getExplosion():IExplosion {
        return _explosionsBuilder.make(ExplosionType.ATOM, block.x, block.y)
    }

}
}