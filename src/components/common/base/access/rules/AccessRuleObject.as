package components.common.base.access.rules {
public class AccessRuleObject {
    public var accessRule:IAccessRule;
    public var isSuccess:Boolean;

    public function AccessRuleObject(accessRuleP:IAccessRule, isSuccessP:Boolean) {
        accessRule = accessRuleP;
        isSuccess = isSuccessP;
    }
}
}