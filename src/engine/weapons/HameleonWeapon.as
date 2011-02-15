/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.utils.ViewState
import engine.weapons.interfaces.IDeactivatableWeapon

import flash.display.BlendMode

public class HameleonWeapon implements IDeactivatableWeapon {

    private var _charges:int;
    private var _duration:Number

    private var _isActivated:Boolean;
    private var _activatedOn:IBomber;

    public function HameleonWeapon(duration:Number = 5.0, charges:int = 3) {
        _charges = charges;
        _duration = duration;
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

    public function get type():WeaponType {
        return WeaponType.HAMELEON;
    }

    // accessors
    public function get isActivated():Boolean {
        return _isActivated;
    }

    public function get charges():int {
        return _charges
    }

    public function get duration():Number {
        return _duration
    }
}
}