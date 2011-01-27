package components.common.base.access.rules.itemrule {
import components.common.base.access.rules.AccessRuleType
import components.common.base.access.rules.IAccessRule
import components.common.items.ItemProfileObject
import components.common.items.ItemType

public class AccessItemRule implements IAccessRule {
    private var type:AccessRuleType;
    private var _items:Array;
    /* type = [ItemType, ItemType, ...] */
    private var _allItemsIsNessesory:Boolean;

    public function AccessItemRule(items:Array, allItemsIsNessesory:Boolean = false) {
        type = AccessRuleType.ITEM_RULE;
        _items = new Array();

        for each(var i:ItemType in items) {
            _items.push(i);
        }

        _allItemsIsNessesory = allItemsIsNessesory;
    }

    public function get items():Array {
        return _items;
    }

    public function get allItemsIsNessesory():Boolean {
        return _allItemsIsNessesory;
    }

    public function checkAccess():Boolean {
        var res:Boolean = false;
        var oneItemIsFinded:Boolean = false;

        // check for all items
        for each(var itn:ItemType in _items) {
            for each(var it:ItemProfileObject in Context.Model.currentSettings.ownGameProfile.gotItems) {
                if (it.itemType != itn) {
                    res = false;
                } else {
                    oneItemIsFinded = true;
                }
            }
        }

        if (!_allItemsIsNessesory && oneItemIsFinded) {
            res = true;
        }


        return res;
    }

    public function getAccessRuleType():AccessRuleType {
        return type;
    }
}
}