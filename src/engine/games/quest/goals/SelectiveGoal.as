/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

import mx.collections.ArrayCollection

public class SelectiveGoal extends GoalBase implements IGoal {

    private var _goals:ArrayCollection;
    public static const name:String = "SelectiveGoal"

    public function SelectiveGoal(text:String, goals:ArrayCollection) {
        super(text)
        _goals = goals
    }


    public function check(game:IQuestGame):Boolean {
        for each(var g:IGoal in _goals) {
            if (g.check(game))
                return true
        }
        return false
    }

    public function get goals():ArrayCollection {
        return _goals
    }
}
}
