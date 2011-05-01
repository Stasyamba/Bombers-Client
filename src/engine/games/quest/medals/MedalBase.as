/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
import engine.games.quest.goals.IGoal

public class MedalBase {

    private var _prizes:Array
    private var _text:String
    private var _goal:IGoal

    public function MedalBase(text:String, prizes:Array,goal:IGoal) {
        _prizes = prizes
        _text = text
        _goal = goal
    }

    public function get text():String {
        return _text
    }

    //ResourceObject,ExperienceObject,ItemProfileObject
    public function get prizes():Array {
        return _prizes
    }


    public function get goal():IGoal {
        return _goal
    }
}
}
