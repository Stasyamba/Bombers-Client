/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.weapons.interfaces.IWeapon

public class NullWeapon implements IWeapon {
    public function NullWeapon() {
    }

    public function activateAt(x:uint, y:uint, by:IBomber):void {
    }

    public function canActivateAt(x:uint, y:uint):Boolean {
        return false;
    }

    public function get type():WeaponType {
        return WeaponType.NULL;
    }
}
}