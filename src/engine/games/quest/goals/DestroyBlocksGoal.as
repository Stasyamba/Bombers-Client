/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame
import engine.maps.mapBlocks.MapBlockType

public class DestroyBlocksGoal extends GoalBase implements IGoal {

    public static const name:String = "DestroyBlocksGoal";
    private var _amount:MapBlockAmount;

    public function DestroyBlocksGoal(text:String, amount:MapBlockAmount) {
        super(text)
        _amount = amount;
    }

    public function check(game:IQuestGame):Boolean {
        var i:int = 0;
        for each (var obj:DestroyedMapBlockObject in game.gameStats.destroyedBlocks.source) {
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
