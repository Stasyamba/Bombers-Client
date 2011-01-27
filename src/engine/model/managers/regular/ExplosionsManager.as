/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.EngineContext
import engine.explosionss.*
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock
import engine.model.explosionss.ExplosionType
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager

import mx.collections.ArrayList

public class ExplosionsManager implements IExplosionsManager {
    protected var explosions:ArrayList = new ArrayList();
    protected var explosionsBuilder:ExplosionsBuilder;
    protected var mapManager:IMapManager;
    protected var playerManager:IPlayerManager;

    protected var _allExplosions:IExplosion;
    protected var enemiesManager:IEnemiesManager;


    public function ExplosionsManager(explosionsBuilder:ExplosionsBuilder, mapManager:IMapManager, playerManager:IPlayerManager, enemiesManager:IEnemiesManager) {
        this.explosionsBuilder = explosionsBuilder;
        this.mapManager = mapManager;
        this.playerManager = playerManager;
        this.enemiesManager = enemiesManager
    }

    public function addExplosions(expls:ArrayList):void {
        for each (var e:IExplosion in expls.source) {
            if (!e.expired())
                explosions.addItem(e);
        }
        updateAllExplosions();
        for each (e in expls.source) {
            e.forEachPoint(function (point:ExplosionPoint):void {
                var b:IMapBlock = mapManager.map.getBlock(point.x, point.y);
                b.explode(e);
            })
            playerManager.checkPlayerMetExplosion(e);
        }
    }

    public function updateAllExplosions():void {
        var explType:ExplosionType = getAllExplosionsType();
        var result:IExplosion = explosionsBuilder.make(explType);

        for each (var block:IMapBlock in mapManager.map.blocks) {
            var type:ExplosionPointType = ExplosionPointType.NONE;
            for each (var expl:IExplosion in explosions.source) {
                var p:ExplosionPoint = expl.getPoint(block.x, block.y);
                if (p != null) {
                    if (type == ExplosionPointType.NONE)
                        type = p.type;
                    else {
                        type = addTypes(type, p.type);
                        if (type == ExplosionPointType.CROSS)
                            break;
                    }
                }
            }
            if (type != ExplosionPointType.NONE)
                result.addPoint(new ExplosionPoint(block.x, block.y, type))
        }
        _allExplosions = result;
        EngineContext.explosionsUpdated.dispatch(result);
    }

    private function addTypes(type1:ExplosionPointType, type2:ExplosionPointType):ExplosionPointType {
        if (type1 == type2)
            return type1;
        if (bothAreOneOf(type1, type2, ExplosionPointType.HORIZONTAL, ExplosionPointType.LEFT, ExplosionPointType.RIGHT))
            return ExplosionPointType.HORIZONTAL
        if (bothAreOneOf(type1, type2, ExplosionPointType.VERTICAL, ExplosionPointType.UP, ExplosionPointType.DOWN))
            return ExplosionPointType.VERTICAL;
        return ExplosionPointType.CROSS;
    }

    private function bothAreOneOf(type1:ExplosionPointType, type2:ExplosionPointType, ...args):Boolean {
        var r1:Boolean = false;
        var r2:Boolean = false;

        for (var i:int = 0; i < args.length; i++) {
            if ((!r1) && (type1 == (args[i] as ExplosionPointType))) {
                r1 = true;
            }
            if ((!r2) && (type2 == (args[i] as ExplosionPointType))) {
                r2 = true;
            }
        }
        return r1 && r2;
    }

    private function getAllExplosionsType():ExplosionType {
        if (explosions.length == 0)
            return ExplosionType.NULL;
        var result:ExplosionType = (explosions.getItemAt(0) as IExplosion).type
        for each (var expl:IExplosion in explosions) {
            if (expl.type != result)
                return ExplosionType.COMPLEX;
        }
        return result;
    }

    public function checkExplosions(elapsedMiliSecs:Number):void {
        var elapsedSecs:Number = elapsedMiliSecs / 1000;
        var changed:Boolean = false;
        var removed:ArrayList = new ArrayList();

        var l:int = explosions.length;
        for (var i:int = 0; i < l; i++) {
            var expl:IExplosion = explosions.getItemAt(i) as IExplosion;
            expl.expireBy(elapsedSecs);
            if (expl.expired()) {
                explosions.removeItem(expl);
                removed.addItem(expl);
                changed = true;
                l--;
                i--;
            } else {
                playerManager.checkPlayerMetExplosion(expl);
            }
        }
        if (changed) {
            EngineContext.explosionsRemoved.dispatch(removed)
            updateAllExplosions();
        }
    }

    public function get allExplosions():IExplosion {
        return _allExplosions;
    }

}
}