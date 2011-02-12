/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.weapons.interfaces.IWeapon

public class NullWeapon implements IWeapon {

    private static var _instance:NullWeapon

    public static function get instance():NullWeapon{
        if (_instance == null)
            _instance = new NullWeapon()
        return _instance
    }

    function NullWeapon() {
    }

    public function get type():WeaponType {
        return WeaponType.NULL;
    }
}
}