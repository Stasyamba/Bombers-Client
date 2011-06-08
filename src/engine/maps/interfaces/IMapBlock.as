/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.model.explosionss.ExplosionType

import org.osflash.signals.Signal

//add signals
public interface IMapBlock extends IMapBlockState {

    function get x():int;

    function get y():int;

    function get state():IMapBlockState

    function get object():IDynObject;

    //result - if object is active
    function setObject(object:IDynObject):Boolean;

    function collectObject(byMe:Boolean):void;

    function get viewUpdated():Signal;

    function get hasExplosionPrint():Boolean;

    function get isExplodingNow():Boolean;

    function get explodedBy():ExplosionType;

    function get explosionStarted():Signal;

    function get explosionStopped():Signal;

    function stopExplosion():void;

    function setDieWall():void;

    function get objectCollected():Signal;

    function get objectSet():Signal;

    function setState(state:IMapBlockState):void;

    function get destroyed():Signal;
}
}