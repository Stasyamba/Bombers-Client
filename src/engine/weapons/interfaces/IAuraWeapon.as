/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons.interfaces {
import engine.bombers.interfaces.IBomber

public interface IAuraWeapon extends IWeapon {
    function enableFor(seconds:Number, on:IBomber):void

    function enable(on:IBomber):void

    function disableFor(seconds:Number, on:IBomber):void

    function disable(on:IBomber):void
}
}
