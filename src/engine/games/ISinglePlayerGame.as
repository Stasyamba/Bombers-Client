/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games {
import engine.games.single.GameStats
import engine.games.single.goals.IGoal

public interface ISinglePlayerGame extends IGame {

    function get gameStats():GameStats;

    function addGoal(goal:IGoal):void;
}
}
