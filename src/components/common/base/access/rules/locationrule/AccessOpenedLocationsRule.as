package components.common.base.access.rules.locationrule {
import components.common.base.access.rules.AccessRuleType
import components.common.base.access.rules.IAccessRule
import components.common.worlds.locations.LocationType

public class AccessOpenedLocationsRule implements IAccessRule {
    private var type:AccessRuleType;

    private var _nessesoryLocations:Array = new Array();
    private var _allLocationsIsNessesory:Boolean = false;

    /* get content */

    public function get allLocationsIsNessesory():Boolean {
        return _allLocationsIsNessesory;
    }

    public function get nessesoryLocations():Array {
        return _nessesoryLocations;
    }


    public function AccessOpenedLocationsRule(locations:Array, allLocationsIsNessesoryP:Boolean = false) {
        // INITIALIZAION ONLY HERE!!!!
        type = AccessRuleType.OPENED_LOCATIONS_RULE;

        for each(var l:LocationType in locations) {
            _nessesoryLocations.push(l);
        }

        _allLocationsIsNessesory = allLocationsIsNessesoryP;
    }


    public function checkAccess():Boolean {
        var res:Boolean = true;
        var oneLocationIsFinded:Boolean = false;

        // check for all location
        for each(var ltn:LocationType in _nessesoryLocations) {
            for each(var lt:LocationType in Context.Model.currentSettings.gameProfile.openedLocations) {
                if (lt != ltn) {
                    res = false;
                } else {
                    oneLocationIsFinded = true;
                }
            }
        }

        if (!_allLocationsIsNessesory && oneLocationIsFinded) {
            res = true;
        }

        return res;
    }

    public function getAccessRuleType():AccessRuleType {
        return type;
    }

}
}