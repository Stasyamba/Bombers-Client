/*
 * Copyright (c) 2011.
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

public class DynamiteBomb extends BombBase implements IBomb {
    private static const EXPLODE_TIME:Number = 3;

    public function DynamiteBomb(mapManager:IMapManager, explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(mapManager, explosionsBuilder, block, player);
        _explodeTime = EXPLODE_TIME;
    }


    public function get power():int {
        return 4;
    }

    public function set power(value:int):void {
    }

    public function explode():IExplosion {
        var expl:IExplosion = _explosionsBuilder.make(ExplosionType.DYNAMITE, block.x, block.y)
        expl.perform();
        return expl;
    }

    public function get type():BombType {
        return BombType.DYNAMITE;
    }

    public function onSet():void {
        //do nothing
    }
}
}
