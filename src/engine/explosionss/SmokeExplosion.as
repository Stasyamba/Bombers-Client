/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.model.explosionss.ExplosionType

public class SmokeExplosion extends ExplosionBase implements IExplosion {
    public function SmokeExplosion(map:IMap, centerX:int = -1, centerY:int = -1) {
        super(map, centerX, centerY)
        timeToLive = type.timeToLive
    }

    public function perform():void {
        addPoint(new ExplosionPoint(centerX, centerY, ExplosionPointType.CROSS));
    }

    public function get type():ExplosionType {
        return ExplosionType.SMOKE;
    }

    public function get damage():int {
        return 0;
    }
}
}
