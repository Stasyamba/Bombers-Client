/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.DynObjectType

public class GoalsBuilder {
    public function GoalsBuilder() {
    }

    public static function makeFromXml(xml:XML):IGoal {
        switch (String(xml.name())) {
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
        }
        throw new ArgumentError("invalid goal xml " + xml.name())
    }

    private static function makeDestroyBOGoal(xml:XML):DestroyBOGoal {
        return new DestroyBOGoal(xml.@id)
    }

    private static function makeActivateBOGoal(xml:XML):ActivateBOGoal {
        return new ActivateBOGoal(xml.@id)
    }

    private static function makeReachCoordsGoal(xml:XML):ReachCoordsGoal {
        return new ReachCoordsGoal(int(xml.@x), int(xml.@y))
    }

    private static function makeCollectObjectsGoal(xml:XML):IGoal {
        return new CollectObjectsGoal(new MapObjectAmount(DynObjectType.byKey(xml.@type), int(xml.@amount)))
    }

    private static function makeDefeatEnemyGoal(xml:XML):DefeatEnemyGoal {
        var all:Boolean = (xml.@id == "all");
        if (all)
            return new DefeatEnemyGoal(true)
        else
            return new DefeatEnemyGoal(false, int(xml.@id))
    }

    private static function makeDestroyBlocksGoal(xml:XML):DestroyBlocksGoal {
        return new DestroyBlocksGoal((new MapBlockAmount(MapBlockType.byKey(xml.@type), int(xml.@amount))))
    }
}
}
