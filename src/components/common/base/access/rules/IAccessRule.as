package components.common.base.access.rules {
public interface IAccessRule {
    function getAccessRuleType():AccessRuleType;

    function checkAccess():Boolean;
}
}