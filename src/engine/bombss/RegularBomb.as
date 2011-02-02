/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.bombss.interfaces.IBomb
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock
import engine.model.explosionss.ExplosionType
import engine.model.managers.interfaces.IMapManager

public class RegularBomb extends BombBase implements IBomb {

    private static const EXPLODE_TIME:Number = 2;

    protected var _power:int;

    public function RegularBomb(mapManager:IMapManager, explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(mapManager, explosionsBuilder, block, player);

        _power = player.bombPower;
        _explodeTime = EXPLODE_TIME;
    }


    public function explode():IExplosion {
        var expl:IExplosion = _explosionsBuilder.make(ExplosionType.REGULAR, block.x, block.y, power)
        expl.perform();
        _owner.returnBomb();
        return expl;
    }

    public function set power(value:int):void {
        _power = value;
    }

    public function get power():int {
        return _power;
    }

    public function get type():BombType {
        return BombType.REGULAR;
    }

    public function onSet():void {
        owner.takeBomb();
    }
}
}