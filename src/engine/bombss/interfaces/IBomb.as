/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss.interfaces {
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject

public interface IBomb extends IDynObject {

    function explode():IExplosion;

    function get exploded():Boolean;


    function get power():int;

    /*
     * to perform explosion with custom power
     * */
    function set power(value:int):void;

    function get owner():IBomber;


    function onSet():void;
}
}