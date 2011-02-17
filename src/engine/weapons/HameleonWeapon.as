/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.utils.ViewState
import engine.weapons.interfaces.IDeactivatableWeapon

import flash.display.BlendMode

public class HameleonWeapon extends DeactivatableWeaponBase implements IDeactivatableWeapon {

    public static const DURATION:int = 20000

    private var _activatedOn:IBomber;

    public function HameleonWeapon(duration:int = DURATION, charges:int = 3) {
        super(charges, duration)
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        return charges > 0 && !_isActivated;
    }

    public function canDeactivate(x:int, y:int, by:IBomber):Boolean {
        return _isActivated && (_activatedOn == by);
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        _charges--;
        by.stateAdded.dispatch(new ViewState(ViewState.HAMELEON, {alpha:0.3,blendMode:BlendMode.MULTIPLY}))
        _activatedOn = by;
        _isActivated = true;
    }

    public function deactivate(by:IBomber):void {
        by.stateRemoved.dispatch(ViewState.HAMELEON)
        _activatedOn = null;
        _isActivated = false;
    }

    public function deactivateStatic(by:IBomber):void {
        by.stateRemoved.dispatch(ViewState.HAMELEON)
    }

    public function activateStatic(by:IBomber, x:int, y:int):void {
        by.stateAdded.dispatch(new ViewState(ViewState.HAMELEON, {alpha:0.3,blendMode:BlendMode.MULTIPLY}))
    }

    public override function get type():WeaponType {
        return WeaponType.HAMELEON;
    }

    // accessors
}
}