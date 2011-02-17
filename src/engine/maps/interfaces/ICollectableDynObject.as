/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
public interface ICollectableDynObject extends IDynObject {
    function tryToTake():void;

    function get wasTriedToBeTaken():Boolean;
}
}
