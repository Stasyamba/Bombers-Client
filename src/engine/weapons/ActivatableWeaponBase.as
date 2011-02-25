/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext

public class ActivatableWeaponBase {
    protected var _charges:int;

    public function ActivatableWeaponBase(charges:int) {
        _charges = charges
    }

    public function get charges():int {
        return _charges
    }

    public function decCharges():void {
        _charges--
        trace("minus charges " + type.key + ", now " + _charges)
        EngineContext.weaponUnitSpent.dispatch(type)
    }

    public function get type():WeaponType {
        throw Error("abstract method call")
    }
}
}
