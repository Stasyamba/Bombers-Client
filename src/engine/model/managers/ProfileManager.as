/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers {
import engine.bombers.interfaces.IGameSkills
import engine.bombers.skin.BomberSkin
import engine.model.managers.interfaces.IProfileManager
import engine.profiles.GameProfile

public class ProfileManager implements IProfileManager {
    private var _profile:GameProfile;

    public function ProfileManager(profile:GameProfile) {
        _profile = profile;
    }

    public function getSkin():BomberSkin {
        //return _profile.getSkin();
        return null;
    }

    public function getMapSkills():IGameSkills {

        return _profile.getGameSkills();
    }

    public function get name():String {
        return _profile.name;
    }
}
}