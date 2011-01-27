/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.single.goals {
import engine.bombers.interfaces.IEnemyBomber
import engine.games.ISinglePlayerGame

public class DefeatEnemyGoal implements IGoal {
    private var _id:int;
    private var _all:Boolean;
    public static const name:String = "DefeatEnemyGoal";

    public function checkAll(game:ISinglePlayerGame):Boolean {
        var aliveFlag:Boolean = false;
        game.enemiesManager.forEachAliveEnemy(function todo(enemy:IEnemyBomber, playerId:int):void {
            aliveFlag = true;
        })
        return !aliveFlag;
    }

    private function checkOne(game:ISinglePlayerGame):Boolean {
        var aliveFlag:Boolean = false;
        game.enemiesManager.forEachAliveEnemy(function todo(enemy:IEnemyBomber, playerId:int):void {
            if (playerId == _id)
                aliveFlag = true;
        })
        return !aliveFlag;
    }

    public function check(game:ISinglePlayerGame):Boolean {
        if (all)
            return checkAll(game)
        return checkOne(game);
    }

    public function DefeatEnemyGoal(all:Boolean, id:int = 0) {
        _all = all;
        if (all) return;
        _id = id;
    }

    public function get id():int {
        return _id;
    }

    public function get all():Boolean {
        return _all;
    }
}
}
