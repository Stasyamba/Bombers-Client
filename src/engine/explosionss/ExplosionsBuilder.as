/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.model.explosionss.ExplosionType
import engine.model.managers.interfaces.IMapManager

public class ExplosionsBuilder {
    private var mapManager:IMapManager;

    public function ExplosionsBuilder(mapManager:IMapManager) {
        this.mapManager = mapManager;
    }

    public function make(explType:ExplosionType, owner:IBomber, centerX:int = -1, centerY:int = -1, power:int = -1):IExplosion {
        switch (explType) {
            case ExplosionType.REGULAR:
                return new RegularExplosion(mapManager.map, owner, centerX, centerY, power)
            case ExplosionType.ATOM:
                return new AtomExplosion(mapManager.map, owner, centerX, centerY)
            case ExplosionType.BOX:
                return new BoxExplosion(mapManager.map, centerX, centerY)
            case ExplosionType.DYNAMITE:
                var e:RegularExplosion = new RegularExplosion(mapManager.map, owner, centerX, centerY, 2)
                e.damage = 2;
                return e
            case ExplosionType.SMOKE:
                return new SmokeExplosion(mapManager.map, owner, centerX, centerY)
            case ExplosionType.NULL:
                return NullExplosion.getInstance();
        }
        throw new ArgumentError("Not implemented making explosions of type \"" + explType.value + "\"")
    }
}
}