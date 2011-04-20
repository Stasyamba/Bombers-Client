/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import engine.games.*;
import engine.games.quest.GameStats
import engine.games.quest.goals.IGoal

public interface IQuestGame extends IGame {

    function get gameStats():GameStats;

    function addGoal(goal:IGoal):void;
}
}
