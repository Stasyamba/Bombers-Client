/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.interfaces.IBomber

public interface ITimeActivatableDynObject extends IDynObject {

    function get timeToActivate():int;

    function onTimeElapsed(elapsedMilliSecs:int):void;

    function addVictim(player:IBomber):void

    function get victim():IBomber

    function get owner():IBomber
}
}
