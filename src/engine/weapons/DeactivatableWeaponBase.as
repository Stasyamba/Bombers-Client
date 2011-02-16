/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
public class DeactivatableWeaponBase extends ActivatableWeaponBase {
    protected var _duration:int

    protected var _isActivated:Boolean;

    public function DeactivatableWeaponBase(charges:int, duration:int) {
        super(charges)
        _duration = duration
    }

    public function get isActivated():Boolean {
        return _isActivated;
    }

    public function get duration():int {
        return _duration
    }
}
}
