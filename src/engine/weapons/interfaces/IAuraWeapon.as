/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons.interfaces {
import engine.bombers.interfaces.IBomber

public interface IAuraWeapon extends IWeapon {
    function enableFor(milliseconds:int, on:IBomber):void

    function enable(on:IBomber):void

    function disableFor(milliseconds:int, on:IBomber):void

    function disable(on:IBomber):void
}
}
