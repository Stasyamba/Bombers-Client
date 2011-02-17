/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.single.goals {
import engine.games.ISinglePlayerGame
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType

public class CollectObjectsGoal implements IGoal {

    private var _amount:MapObjectAmount;
    public static const name:String = "CollectObjectsGoal";

    public function CollectObjectsGoal(amount:MapObjectAmount) {
        _amount = amount
    }

    public function get amount():MapObjectAmount {
        return _amount;
    }

    public function get objectType():IDynObjectType {
        return amount.type
    }

    public function check(game:ISinglePlayerGame):Boolean {
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
