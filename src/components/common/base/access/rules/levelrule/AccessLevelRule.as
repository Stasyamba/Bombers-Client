package components.common.base.access.rules.levelrule {
import components.common.base.access.rules.AccessRuleType
import components.common.base.access.rules.IAccessRule

public class AccessLevelRule implements IAccessRule {
    private var type:AccessRuleType;

    private var _minimumLevel:int = 1;

    public function AccessLevelRule(minLevel:int = 1) {
        _minimumLevel = minLevel;
    }

    public function get minimumLevel():int {
        return _minimumLevel;
    }

    public function checkAccess():Boolean {
        type = AccessRuleType.LEVEL_RULE;

        var res:Boolean = false;
        var currentLevel:int = Context.Model.expiranceManager.getLevel(Context.Model.currentSettings.ownGameProfile.expirance);

        if (currentLevel >= minimumLevel) {
            res = true;
        }

        return res;
    }

    public function getAccessRuleType():AccessRuleType {
        return type;
    }

}
}