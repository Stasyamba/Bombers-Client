/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.single.goals {
import engine.games.ISinglePlayerGame

public interface IGoal {
    function check(game:ISinglePlayerGame):Boolean
}
}
