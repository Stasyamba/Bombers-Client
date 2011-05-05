package components.common.base.access.rules.levelrule {
import components.common.base.access.rules.AccessRuleType;
import components.common.base.access.rules.IAccessRule;

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
		try{
	        var currentLevel:int = Context.Model.experianceManager.getLevel(Context.Model.currentSettings.gameProfile.experience).level;
			
	        if (currentLevel >= minimumLevel) {
	            res = true;
	        }
		}catch(e:Error){}
        return res;
    }

    public function getAccessRuleType():AccessRuleType {
        return type;
    }

}
}