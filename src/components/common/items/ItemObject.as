package components.common.items {
import components.common.base.access.rules.AccessRuleObject
import components.common.base.access.rules.IAccessRule

public class ItemObject {
    private var _type:ItemType;
    private var _rulesList:Array;
    private var _viewObject:ItemViewObject;

    public function ItemObject(typeP:ItemType, accessRulesP:Array, viewObject:ItemViewObject) {
        _type = typeP;

        _rulesList = new Array();

        for each(var ar:IAccessRule in accessRulesP) {
            _rulesList.push(ar);
        }

        _viewObject = viewObject;
    }

    public function get viewObject():ItemViewObject {
        return _viewObject;
    }

    public function get type():ItemType {
        return _type;
    }

    public function checkAccess():Array {
        var res:Array = new Array();

        for each(var r:IAccessRule in _rulesList) {
            res.push(new AccessRuleObject(r, r.checkAccess()));
        }

        return res;
    }

    public function addRule(rule:IAccessRule):void {
        _rulesList.push(rule)
    }
}
}