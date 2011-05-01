/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.interfaces.IBomber

public interface IDynObject {

    function canExplosionGoThrough():Boolean;

    function canGoThrough():Boolean;

    function explodesAndStopsExplosion():Boolean;

    function get x():int;

    function get y():int;

    function get block():IMapBlock;

    function get type():IDynObjectType;

    function activateOn(player:IBomber):void;

    //only in multiplayer games!
    function grabCorrespondingWeapon():void

    function get removeAfterActivation():Boolean
}
}