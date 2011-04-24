/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.maps.interfaces.IMapBlock

public interface IMapCoords {

    function get elemX():uint;

    function set elemX(value:uint):void;

    function get elemY():uint;

    function set elemY(value:uint):void;

    function get xDef():Number;

    function set xDef(value:Number):void;

    function get yDef():Number;

    function set yDef(value:Number):void;

    function setXExplicit(x:Number):void;

    function setYExplicit(y:Number):void;

    function stepLeft(moveAmount:Number, spectatorMode:Boolean = false):void;

    function stepRight(moveAmount:Number, spectatorMode:Boolean = false):void;

    function stepUp(moveAmount:Number, spectatorMode:Boolean = false):void;

    function stepDown(moveAmount:Number, spectatorMode:Boolean = false):void;

    function getRealX():Number;

    function getRealY():Number;

    function getPartBlock():IMapBlock;

    function getPartBlockDef():Number;

    function canMoveLeft():Boolean;

    function canMoveRight():Boolean;

    function canMoveUp():Boolean;

    function canMoveDown():Boolean;
}
}