/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IMapObject

public interface IObjectManager {

    function addObject(object:IMapObject):void;

    function checkObjectTaken(elapsedMiliSecs:int):void;

    function takeObject(x:int, y:int, player:IBomber):void;
}
}