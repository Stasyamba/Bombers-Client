/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public class DestroyBOGoal extends GoalBase implements IGoal {

    private var _boId:int

    public static const name:String = "DestroyBOGoal";

    public function DestroyBOGoal(text:String, boId:int) {
        super(text)
        _boId = boId
    }

    public function check(game:IQuestGame):Boolean {
        //return  game.getBO(_boId).isDead;
        return false
    }
}
}
