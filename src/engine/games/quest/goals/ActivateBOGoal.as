/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public class ActivateBOGoal implements IGoal{
    private var _boId:int

    public static const name:String = "DestroyBOGoal";

    public function ActivateBOGoal(boId:int) {
        _boId = boId
    }

    public function check(game:IQuestGame):Boolean {
        //return  game.getBO(_boId).isActivated;
        return false
    }
}
}
