package {
import components.common.utils.SocialProfile;
import components.common.utils.enviroment.ApiResult;
import components.common.utils.enviroment.FlashVars;

import engine.profiles.GameProfile;

[Bindable]
public class Settings {
    public var flashVars:FlashVars = new FlashVars();
    public var apiResult:ApiResult;

    public var applicationSecret:String = "";
    public var authKey:String = "";

    public var gameProfile:GameProfile = new GameProfile();
	public var socialProfile: SocialProfile = new SocialProfile();
	
	
	
    public function Settings() {
    }

}
}