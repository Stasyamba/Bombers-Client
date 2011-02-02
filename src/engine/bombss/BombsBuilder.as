/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.bombss.interfaces.IBomb
import engine.explosionss.ExplosionsBuilder
import engine.maps.interfaces.IMapBlock
import engine.model.managers.regular.MapManager

public class BombsBuilder {

    private var mapManager:MapManager;
    private var explosionsBuilder:ExplosionsBuilder;

    public function BombsBuilder(mapManager:MapManager, explosionsBuilder:ExplosionsBuilder) {
        this.mapManager = mapManager;
        this.explosionsBuilder = explosionsBuilder;
    }

    public function makeBomb(type:BombType, block:IMapBlock, player:IBomber):IBomb {
        switch (type) {
            case BombType.REGULAR:
                return new RegularBomb(mapManager, explosionsBuilder, block, player);
            case BombType.ATOM:
                return new AtomBomb(mapManager, explosionsBuilder, block, player);
            case BombType.BOX:
                return new BoxBomb(mapManager, explosionsBuilder, block, player);
            case BombType.DYNAMITE:
                return new DynamiteBomb(mapManager, explosionsBuilder, block, player);
        }
        throw new ArgumentError(" don't support this bomb type");
    }
}
}