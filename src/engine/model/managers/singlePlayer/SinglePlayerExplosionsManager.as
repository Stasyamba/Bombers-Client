/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.explosionss.*
import engine.explosionss.interfaces.IExplosion
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.*

public class SinglePlayerExplosionsManager extends ExplosionsManager implements IExplosionsManager {


    public function SinglePlayerExplosionsManager(explosionsBuilder:ExplosionsBuilder, mapManager:IMapManager, playerManager:IPlayerManager, enemiesManager:IEnemiesManager) {
        super(explosionsBuilder, mapManager, playerManager, enemiesManager)
    }

    override public function addExplosions(expls:Array):void {
        super.addExplosions(expls);
        for each (var e:IExplosion in expls) {
            enemiesManager.checkEnemiesMetExplosion(e);
        }

    }

    override public function checkExplosions(elapsedMiliSecs:int):void {
        super.checkExplosions(elapsedMiliSecs);
        var l:int = explosions.length;
        for (var i:int = 0; i < l; i++) {
            var expl:IExplosion = explosions.getItemAt(i) as IExplosion;
            enemiesManager.checkEnemiesMetExplosion(expl)
        }
    }
}
}