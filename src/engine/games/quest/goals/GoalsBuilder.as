/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.DynObjectType

import mx.collections.ArrayCollection

public class GoalsBuilder {
    public function GoalsBuilder() {
    }

    public static function array(xml:XMLList):ArrayCollection {
        var res:ArrayCollection = new ArrayCollection()
        for each (var goal:XML in xml.Goal) {
            res.addItem(makeFromXml(goal))
        }
        return res
    }

    public static function makeFromXml(xml:XML):IGoal {
        switch (String(xml.@t)) {
            case DestroyBlocksGoal.name:
                return makeDestroyBlocksGoal(xml)
            case DefeatEnemyGoal.name:
                return makeDefeatEnemyGoal(xml)
            case CollectObjectsGoal.name:
                return makeCollectObjectsGoal(xml)
            case ReachCoordsGoal.name:
                return makeReachCoordsGoal(xml)
            case DestroyBOGoal.name:
                return makeDestroyBOGoal(xml)
            case ActivateBOGoal.name:
                return makeActivateBOGoal(xml)
            case SelectiveGoal.name:
                return makeSelectiveGoal(xml)
        }
        throw new ArgumentError("invalid goal xml " + xml.@t)
    }

    private static function makeSelectiveGoal(xml:XML):IGoal {
        var goals:ArrayCollection = array(xml.goals)
        return new SelectiveGoal(xml.@text, goals)
    }

    private static function makeDestroyBOGoal(xml:XML):DestroyBOGoal {
        return new DestroyBOGoal(xml.@text, xml.@id)
    }

    private static function makeActivateBOGoal(xml:XML):ActivateBOGoal {
        return new ActivateBOGoal(xml.@text, xml.@id)
    }

    private static function makeReachCoordsGoal(xml:XML):ReachCoordsGoal {
        return new ReachCoordsGoal(xml.@text, int(xml.@x), int(xml.@y))
    }

    private static function makeCollectObjectsGoal(xml:XML):IGoal {
        return new CollectObjectsGoal(xml.@text, new MapObjectAmount(DynObjectType.byValue(xml.@type), int(xml.@amount)))
    }

    private static function makeDefeatEnemyGoal(xml:XML):DefeatEnemyGoal {
        var all:Boolean = (xml.@id == "all");
        if (all)
            return new DefeatEnemyGoal(xml.@text, true)
        else
            return new DefeatEnemyGoal(xml.@text, false, int(xml.@id))
    }

    private static function makeDestroyBlocksGoal(xml:XML):DestroyBlocksGoal {
        return new DestroyBlocksGoal(xml.@text, (new MapBlockAmount(MapBlockType.byKey(xml.@type), int(xml.@amount))))
    }


}
}
