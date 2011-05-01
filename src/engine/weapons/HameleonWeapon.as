/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.utils.ViewState
import engine.weapons.interfaces.IDeactivatableWeapon

import flash.display.BlendMode

import greensock.TweenMax

public class HameleonWeapon extends DeactivatableWeaponBase implements IDeactivatableWeapon {

    public static const DURATION:Number = 20

    private var _activatedOn:IBomber;

    public function HameleonWeapon(duration:Number = DURATION, charges:int = 3) {
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

    }

    public function activateStatic(x:int, y:int, by:IBomber):void {
        by.stateAdded.dispatch(new ViewState(ViewState.HAMELEON, {alpha:0.3,blendMode:BlendMode.MULTIPLY}))
    }

    public function qDeactivate(by:IBomber):void {
        qDeactivateStatic(by)
        _activatedOn = null;
        _isActivated = false;
    }

    public function qDeactivateStatic(by:IBomber):void {
        by.stateRemoved.dispatch(ViewState.HAMELEON)
    }

    public function qActivate(x:uint, y:uint, by:IBomber):void {
        _charges--;
        qActivateStatic(x, y, by)
        _activatedOn = by;
        _isActivated = true;
        TweenMax.delayedCall(duration, qDeactivate, [by])
    }

    public function qActivateStatic(x:int, y:int, by:IBomber):void {
        by.stateAdded.dispatch(new ViewState(ViewState.HAMELEON, {alpha:0.3,blendMode:BlendMode.MULTIPLY}))
    }

    public override function get type():WeaponType {
        return WeaponType.HAMELEON;
    }

    // accessors
}
}