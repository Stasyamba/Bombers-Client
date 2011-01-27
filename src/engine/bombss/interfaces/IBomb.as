/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss.interfaces {
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock

public interface IBomb {
    function canExplosionGoThrough():Boolean;

    function canGoThrough():Boolean;

    function explodesAndStopsExplosion():Boolean;

    function explode():IExplosion;

    function get exploded():Boolean;

    function get timeToExplode():int;

    function onTimeElapsed(elapsedSecs:Number):void;

    function get block():IMapBlock;

    function get type():BombType

    function get power():int;

    /*
     * to perform explosion with custom power
     * */
    function set power(value:int):void;

    function get owner():IBomber;


    function onSet():void;
}
}