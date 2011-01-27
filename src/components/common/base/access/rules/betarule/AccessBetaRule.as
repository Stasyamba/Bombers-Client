package components.common.base.access.rules.betarule {
import components.common.base.access.rules.AccessRuleType
import components.common.base.access.rules.IAccessRule

public class AccessBetaRule implements IAccessRule {
    private var type:AccessRuleType = AccessRuleType.BETA_RULE;

    public function AccessBetaRule() {
    }

    public function checkAccess():Boolean {
        var res:Boolean = false;
        return res;
    }

    public function getAccessRuleType():AccessRuleType {
        return type;
    }

}
}