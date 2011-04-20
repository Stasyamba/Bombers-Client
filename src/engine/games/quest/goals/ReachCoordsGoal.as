/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public class ReachCoordsGoal implements IGoal {

    private var _x:int;
    private var _y:int;
    public static const name:String = "ReachCoordsGoal";

    public function ReachCoordsGoal(x:int, y:int) {
        _x = x;
        _y = y;
    }

    public function check(game:IQuestGame):Boolean {
        return (game.playerManager.me.coords.elemX == _x && game.playerManager.me.coords.elemY == _y) ||
                (game.playerManager.me.coords.getPartBlock().x == _x && game.playerManager.me.coords.getPartBlock().y == _y)
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }
}
}
