/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.bombers.interfaces.IEnemyBomber
import engine.games.quest.IQuestGame
import engine.games.quest.monsters.Monster

public class DefeatMonsterGoal extends GoalBase implements IGoal {
    private var _id:int;
    private var _all:Boolean;
    public static const name:String = "DefeatMonsterGoal";

    public function checkAll(game:IQuestGame):Boolean {
        var aliveFlag:Boolean = false;
        game.monstersManager.forEachAliveMonster(function todo(enemy:Monster, slot:int):void {
            aliveFlag = true;
        })
        return !aliveFlag;
    }

    private function checkOne(game:IQuestGame):Boolean {
        var aliveFlag:Boolean = false;
        game.monstersManager.forEachAliveMonster(function todo(enemy:IEnemyBomber, slot:int):void {
            if (slot == _id)
                aliveFlag = true;
        })
        return !aliveFlag;
    }

    public function check(game:IQuestGame):Boolean {
        if (all)
            return checkAll(game)
        return checkOne(game);
    }

    public function DefeatMonsterGoal(text:String, all:Boolean, id:int = 0) {
        super(text)
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
