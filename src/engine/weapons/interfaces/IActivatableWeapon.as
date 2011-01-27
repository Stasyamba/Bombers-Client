/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons.interfaces {
import engine.bombers.interfaces.IBomber

public interface IActivatableWeapon extends IWeapon {

    function canActivate(x:uint, y:uint, by:IBomber):Boolean;

    function activate(x:uint, y:uint, by:IBomber):void;

    function get charges():int;
}
}
