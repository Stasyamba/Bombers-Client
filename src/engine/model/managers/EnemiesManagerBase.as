/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers {
import engine.bombers.interfaces.IEnemyBomber

public class EnemiesManagerBase {
    public function EnemiesManagerBase() {
    }

    protected var _enemies:Array = new Array();
    private var _enemiesCount:int = 0;

    public function addEnemy(enemy:IEnemyBomber):void {
        _enemies[enemy.slot] = enemy;
        _enemiesCount++;
    }

    public function removeEnemyBySlot(slot:int):void {
        _enemies[slot] = null;
        _enemiesCount--;
    }

    public function getEnemyBySlot(slot:int):IEnemyBomber {
        return _enemies[slot];
    }

    public function get enemiesCount():int {
        return _enemiesCount;
    }

    public function hasEnemy(slot:int):Boolean {
        return !(_enemies[slot] == null);
    }


    public function forEachAliveEnemy(todo:Function):void {
        for (var i:int = 0; i < _enemies.length; i++) {
            var enemy:IEnemyBomber = _enemies[i];
            if (enemy != null && !enemy.isDead)
                todo(enemy, i);
        }
    }

    public function moveEnemies(elapsedMilliSecs:int):void {
        forEachAliveEnemy(function (enemy:IEnemyBomber, slot:int):void {
            enemy.move(elapsedMilliSecs);
        })
    }
}
}