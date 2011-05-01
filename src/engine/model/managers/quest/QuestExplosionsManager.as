/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.EngineContext
import engine.explosionss.*
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.*

import mx.collections.ArrayList

public class QuestExplosionsManager extends ExplosionsManager implements IExplosionsManager {

    private var _monstersManager:MonstersManager

    public function QuestExplosionsManager(explosionsBuilder:ExplosionsBuilder, mapManager:IMapManager, playerManager:IPlayerManager, monstersManager:MonstersManager) {
        super(explosionsBuilder, mapManager, playerManager)
        _monstersManager = monstersManager
    }

    override public function addExplosions(expls:Array):void {
        for each (var e:IExplosion in expls) {
            if (!e.expired())
                explosions.addItem(e);
        }
        updateAllExplosions();
        for each (e in expls) {
            e.forEachPoint(function (point:ExplosionPoint):void {
                var b:IMapBlock = mapManager.map.getBlock(point.x, point.y);
                b.explode(e);
            })
            playerManager.checkPlayerMetExplosion(e);
        }
        //monsters
        for each (var e:IExplosion in expls) {
            _monstersManager.checkMonstersMetExplosion(e);
        }

    }

    override public function checkExplosions(elapsedMiliSecs:int):void {
        var changed:Boolean = false;
        var removed:ArrayList = new ArrayList();

        var l:int = explosions.length;
        for (var i:int = 0; i < l; i++) {
            var expl:IExplosion = explosions.getItemAt(i) as IExplosion;
            expl.expireBy(elapsedMiliSecs);
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
        //monsters
        for (i = 0; i < l; i++) {
            var expl:IExplosion = explosions.getItemAt(i) as IExplosion;
            _monstersManager.checkMonstersMetExplosion(expl)
        }
    }
}
}