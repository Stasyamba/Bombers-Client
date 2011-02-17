/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss.interfaces {
import engine.explosionss.ExplosionPoint
import engine.model.explosionss.ExplosionType

public interface IExplosion {

    function perform():void;

    function addPoint(point:ExplosionPoint):void;

    function expireBy(elapsedMilliSecs:int):void;

    function expired():Boolean;

    function get type():ExplosionType;

    /*
     * do(point:ExplosionPoint):void
     * */
    function forEachPoint(todo:Function):void;

    function getPoint(x:int, y:int):ExplosionPoint;

    function get damage():int;

    function get centerX():int;

    function get centerY():int;
}
}