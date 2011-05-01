/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import engine.games.*
import engine.games.quest.goals.IGoal
import engine.games.quest.medals.Medal

public interface IQuestGame extends IGame {

    function get gameStats():GameStats;

    function addGoal(medal:Medal, goal:IGoal):void;
}
}
