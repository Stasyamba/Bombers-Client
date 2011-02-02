/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.weapons.interfaces.IAuraWeapon

public class SpeedAura implements IAuraWeapon {

    private var _bonusValue : int;

    public function SpeedAura(bonusValue:int) {
        _bonusValue = bonusValue
    }

    public function enableFor(seconds:Number, on:IBomber):void {
    }

    public function enable(on:IBomber):void {
    }

    public function disableFor(seconds:Number, on:IBomber):void {
    }

    public function disable(on:IBomber):void {
    }

    public function get type():WeaponType {
        return WeaponType.SPEED_AURA;
    }

    public function get bonusValue():int {
        return _bonusValue
    }
}
}
