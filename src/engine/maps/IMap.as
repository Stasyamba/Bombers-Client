/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.maps.bigObjects.BigObjectBase
import engine.maps.interfaces.IMapBlock
import engine.utils.Direction

import mx.collections.ArrayList

import org.osflash.signals.Signal

public interface IMap {
    function get blocks():Vector.<IMapBlock>;

    function getBlock(x:uint, y:uint):IMapBlock;

    function get width():uint;

    function get height():uint;

    /*
     * returns a neighbour to direction @to of the block at coords (@ofX,@ofY)
     * if such block doesn't exist, returns NullMapBlock instance  
     * */
    function getNeighbour(ofX:int, ofY:int, to:Direction):IMapBlock;

    /*
     * Array of player spawns. spawn is a dynamic object with fields 'x' and 'y' -- coordinates of the spawn block
     * */
    function get spawns():Array;

    function validPoint(x:int, y:int):Boolean;

    function get explosionPrints():ArrayList;

    function get higherBigObjects():Vector.<BigObjectBase>;

    function get lowerBigObjects():Vector.<BigObjectBase>;

    function get decorations():Vector.<BigObjectBase>;

    function get blockDestroyed():Signal;
}
}