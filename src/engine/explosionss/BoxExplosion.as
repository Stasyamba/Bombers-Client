/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType

public class BoxExplosion extends ExplosionBase implements IExplosion {
    public function BoxExplosion(map:IMap, centerX:int = -1, centerY:int = -1) {
        super(map, centerX, centerY)
        timeToLive = type.timeToLive
    }

    public function perform():void {
        addPoint(new ExplosionPoint(centerX, centerY, ExplosionPointType.CROSS));
        for (var x:int = centerX - 1; x <= centerX + 1; x++) {
            for (var y:int = centerY - 1; y <= centerY + 1; y++) {
                if (map.validPoint(x, y) && map.getBlock(x, y).type == MapBlockType.FREE)
                    addPoint(new ExplosionPoint(x, y, ExplosionPointType.CROSS))
            }
        }

    }

    public function get type():ExplosionType {
        return ExplosionType.BOX;
    }

    public function get damage():int {
        return 1;
    }
}
}
