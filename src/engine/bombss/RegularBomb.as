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

public class RegularBomb extends BombBase implements ITimeActivatableDynObject {

    private static const EXPLODE_TIME:int = 2000;

    protected var _power:int;

    public function RegularBomb(explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(explosionsBuilder, block, player);
        _power = player.bombPower;
        _explodeTime = EXPLODE_TIME;
    }

    public override function get type():IDynObjectType {
        return BombType.REGULAR;
    }

    public override function onAddedToMap():void {
        owner.takeBomb()
    }

    override protected function getExplosion():IExplosion {
        return _explosionsBuilder.make(ExplosionType.REGULAR, owner, block.x, block.y, _power)
    }
}
}