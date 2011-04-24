/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public interface IGoal {
    function check(game:IQuestGame):Boolean

    function get text():String
}
}
