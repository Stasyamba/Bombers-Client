/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.single.goals {
import engine.games.ISinglePlayerGame
import engine.maps.mapBlocks.MapBlockType

public class DestroyBlocksGoal implements IGoal {

    public static const name:String = "DestroyBlocksGoal";
    private var _amount:MapBlockAmount;

    public function DestroyBlocksGoal(amount:MapBlockAmount) {
        _amount = amount;
    }

    public function check(game:ISinglePlayerGame):Boolean {
        var i:int = 0;
        for each (var obj:Object in game.gameStats.destroyedBlocks.source) {
            if (obj.type == blockType)
                i++
            if (i >= _amount.amount)
                return true;
        }
        return false;
    }

    private function get blockType():MapBlockType {
        return _amount.type;
    }

    public function get amount():MapBlockAmount {
        return _amount;
    }
}
}
