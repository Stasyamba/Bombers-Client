/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.explosionss.*
import engine.explosionss.interfaces.IExplosion
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.*

public class QuestExplosionsManager extends ExplosionsManager implements IExplosionsManager {

    private var _monstersManager:MonstersManager

    public function QuestExplosionsManager(explosionsBuilder:ExplosionsBuilder, mapManager:IMapManager, playerManager:IPlayerManager, monstersManager:MonstersManager) {
        super(explosionsBuilder, mapManager, playerManager)
        _monstersManager = monstersManager
    }

    override public function addExplosions(expls:Array):void {
        super.addExplosions(expls);
        for each (var e:IExplosion in expls) {
            _monstersManager.checkMonstersMetExplosion(e);
        }

    }

    override public function checkExplosions(elapsedMiliSecs:int):void {
        super.checkExplosions(elapsedMiliSecs);
        var l:int = explosions.length;
        for (var i:int = 0; i < l; i++) {
            var expl:IExplosion = explosions.getItemAt(i) as IExplosion;
            _monstersManager.checkMonstersMetExplosion(expl)
        }
    }
}
}