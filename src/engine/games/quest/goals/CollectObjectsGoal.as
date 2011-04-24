/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.IQuestGame
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType

public class CollectObjectsGoal extends GoalBase implements IGoal {

    private var _amount:MapObjectAmount;
    public static const name:String = "CollectObjectsGoal";

    public function CollectObjectsGoal(text:String, amount:MapObjectAmount) {
        super(text)
        _amount = amount
    }

    public function get amount():MapObjectAmount {
        return _amount;
    }

    public function get objectType():IDynObjectType {
        return amount.type
    }

    public function check(game:IQuestGame):Boolean {
        var i:int = 0;
        for each (var mapObject:IDynObject in game.gameStats.collectedObjects.source) {
            if (mapObject.type == _amount.type)
                i++
            if (i >= _amount.amount)
                return true
        }
        return false;
    }
}


}
