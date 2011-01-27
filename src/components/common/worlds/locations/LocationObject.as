package components.common.worlds.locations {
import components.common.base.access.rules.AccessRuleObject
import components.common.base.access.rules.IAccessRule

public class LocationObject {
    private var _type:LocationType;
    private var _rulesList:Array = new Array();

    public function LocationObject(type:LocationType, rules:Array) {
        _type = type;
        for each(var r:IAccessRule in rules) {
            _rulesList.push(r);
        }
    }

    public function get type():LocationType {
        return _type;
    }

    public function checkAccess():Array {
        var res:Array = new Array();

        for each(var r:IAccessRule in _rulesList) {
            res.push(new AccessRuleObject(r, r.checkAccess()));
        }

        return res;
    }
}
}