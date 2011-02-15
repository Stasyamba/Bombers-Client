/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons.interfaces {
import engine.bombers.interfaces.IBomber

public interface IDeactivatableWeapon extends IActivatableWeapon {

    function canDeactivate(x:int, y:int, by:IBomber):Boolean

    function deactivate(by:IBomber):void

    function get isActivated():Boolean

    function get duration():Number;

    function deactivateStatic(b:IBomber):void
}
}
