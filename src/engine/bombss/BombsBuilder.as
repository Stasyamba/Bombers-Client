/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.bombss.interfaces.IBomb
import engine.explosionss.ExplosionsBuilder
import engine.maps.interfaces.IMapBlock

public class BombsBuilder {

    private var explosionsBuilder:ExplosionsBuilder;

    public function BombsBuilder(explosionsBuilder:ExplosionsBuilder) {
        this.explosionsBuilder = explosionsBuilder;
    }

    public function makeBomb(type:BombType, block:IMapBlock, player:IBomber):IBomb {
        switch (type) {
            case BombType.REGULAR:
                return new RegularBomb(explosionsBuilder, block, player);
            case BombType.ATOM:
                return new AtomBomb(explosionsBuilder, block, player);
            case BombType.BOX:
                return new BoxBomb(explosionsBuilder, block, player);
            case BombType.DYNAMITE:
                return new DynamiteBomb(explosionsBuilder, block, player);
        }
        throw new ArgumentError(" don't support this bomb type");
    }
}
}