/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public class ActivateBOGoal extends GoalBase implements IGoal {
    private var _boId:int

    public static const name:String = "ActivateBOGoal";

    public function ActivateBOGoal(text:String, boId:int) {
        super(text)
        _boId = boId
    }

    public function check(game:IQuestGame):Boolean {
        //return  game.getBO(_boId).isActivated;
        return false
    }
}
}
