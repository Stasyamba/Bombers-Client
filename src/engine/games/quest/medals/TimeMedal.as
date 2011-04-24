/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
public class TimeMedal extends MedalBase {

    private var _time:int

    public function TimeMedal(text:String, prizes:Array, time:int) {
        super(text, prizes)
        _time = time
    }

    public function get time():int {
        return _time
    }
}
}
