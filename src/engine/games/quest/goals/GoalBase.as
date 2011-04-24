/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
public class GoalBase {

    private var _text:String

    public function GoalBase(text:String) {
        _text = text
    }

    public function get text():String {
        return _text
    }
}
}
