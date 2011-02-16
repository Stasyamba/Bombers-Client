/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IDynObject

public interface IDynObjectManager {

    function addObject(object:IDynObject):void;

    function checkObjectsActivated(elapsedMiliSecs:int):void;

    function activateObject(x:int, y:int, player:IBomber):void;
}
}