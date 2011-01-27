package components.common.base.access.rules.pricerule {
import components.common.base.access.rules.AccessRuleType
import components.common.base.access.rules.IAccessRule
import components.common.resources.ResourcePrice

public class AccessResourcePriceRule implements IAccessRule {
    private var type:AccessRuleType = AccessRuleType.PRICE_RULE;
    private var resourcePrice:ResourcePrice = null;

    public function AccessResourcePriceRule(rp:ResourcePrice = null) {
        if (rp != null) {
            resourcePrice = rp.clone();
        }
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