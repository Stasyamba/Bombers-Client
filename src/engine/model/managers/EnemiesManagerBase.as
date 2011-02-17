/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers {
import engine.bombers.interfaces.IEnemyBomber

import flash.utils.Dictionary

public class EnemiesManagerBase {
    public function EnemiesManagerBase() {
    }

    private var enemies:Dictionary = new Dictionary();
    private var _enemiesCount:int = 0;

    public function addEnemy(enemy:IEnemyBomber):void {
        enemies[enemy.playerId] = enemy;
        _enemiesCount++;
    }

    public function removeEnemyById(playerId:int):void {
        enemies[playerId] = null;
        _enemiesCount--;
    }

    public function getEnemyById(playerId:int):IEnemyBomber {
        return enemies[playerId];
    }

    public function get enemiesCount():int {
        return _enemiesCount;
    }

    public function hasEnemy(playerId:int):Boolean {
        return !(enemies[playerId] == null);
    }


    public function forEachAliveEnemy(todo:Function):void {
		//todo:renove this shit
        for (var i:int = 1; i <= 5; i++) {
            var enemy:IEnemyBomber = enemies[i];
            if (enemy != null && !enemy.isDead)
                todo(enemy, i);
        }
    }

    public function moveEnemies(elapsedMilliSecs:int):void {
        forEachAliveEnemy(function (enemy:IEnemyBomber, playerId:int):void {
            enemy.move(elapsedMilliSecs);
        })
    }
}
}