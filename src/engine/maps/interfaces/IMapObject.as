/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.interfaces.IBomber

public interface IMapObject {

    function canExplosionGoThrough():Boolean;

    function canGoThrough():Boolean;

    function explodesAndStopsExplosion():Boolean;

    function get x():int;

    function get y():int;

    function get block():IMapBlock;

    function get type():IMapObjectType;

    function activateOn(player:IBomber):void;

    function tryToTake():void;

    function get wasTriedToBeTaken():Boolean;
}
}