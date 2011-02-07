package components.common.worlds.locations {
import components.common.base.access.rules.betarule.AccessBetaRule
import components.common.base.access.rules.itemrule.AccessItemRule
import components.common.base.access.rules.levelrule.AccessLevelRule
import components.common.base.access.rules.locationrule.AccessOpenedLocationsRule
import components.common.items.ItemType

public class LocationManager {
    private var locations:Array = new Array();

    public function LocationManager() {
        locations.push(new LocationObject(
                LocationType.WORLD1_GRASSFIELDS,
                []
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_CASTLE,
                []
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_SNOWPEAK,
                [new AccessLevelRule(4),
                    new AccessItemRule([ItemType.QUEST_ITEM_SNOWBOOTS], false)]
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_MINE,
                [new AccessLevelRule(5),
                    new AccessItemRule([ItemType.QUEST_ITEM_CANARY], false)]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_UFO,
                [new AccessOpenedLocationsRule([LocationType.WORLD1_SNOWPEAK], true)]
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_SEA,
                [new AccessLevelRule(3)]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_ROCKET,
                [new AccessLevelRule(5),
                    new AccessOpenedLocationsRule([LocationType.WORLD1_SEA, LocationType.WORLD1_UFO], true),
                    new AccessItemRule([], false)]
                ));

        //, new AccessItemRule([ItemType.QUEST_ITEM_SNOWBOOTS]) - INITIALIZATION ERROR!

        locations.push(new LocationObject(
                LocationType.WORLD1_SATTELITE,
                [new AccessBetaRule()]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_MOON,
                [new AccessOpenedLocationsRule([LocationType.WORLD1_SATTELITE], true)]
                ));
    }


    public function getLocations():Array {
        return locations;
    }

    public function getLocation(locationType:LocationType):LocationObject {
        var res:LocationObject = null;

        for each(var loc:LocationObject in locations) {
            if (loc.type == locationType) {
                res = loc;
            }
        }

        return res;
    }
}
}