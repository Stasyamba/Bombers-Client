/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
import engine.games.quest.goals.IGoal

public class TimeMedal extends MedalBase {

    private var _time:int

    public function TimeMedal(text:String, prizes:Array, goal:IGoal, time:Number) {
        super(text, prizes, goal)
        _time = time
    }

    public function get time():int {
        return _time
    }
}
}
