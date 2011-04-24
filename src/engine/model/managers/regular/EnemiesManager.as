/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.bombers.interfaces.IEnemyBomber
import engine.explosionss.interfaces.IExplosion
import engine.games.quest.monsters.Monster
import engine.maps.interfaces.IDynObject
import engine.model.managers.EnemiesManagerBase
import engine.model.managers.interfaces.IEnemiesManager

public class EnemiesManager extends EnemiesManagerBase implements IEnemiesManager {

    public function EnemiesManager() {
    }

    public function addMonster(monster:Monster):void {
        throw new Error("can't add monster to regular enemies manager")
    }

    public function checkEnemiesMetExplosion(e:IExplosion):void {
        throw new Error("call is not allowed")
    }

    public function checkEnemyTakenObject(enemie:IEnemyBomber, object:IDynObject):Boolean {
        throw new Error("call is not allowed")
    }
}
}