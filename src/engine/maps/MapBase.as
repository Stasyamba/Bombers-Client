/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.maps.bigObjects.BigObjectBase
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.utils.Direction

import mx.collections.ArrayList

import org.osflash.signals.Signal

public class MapBase {
    public var blockBuilder:MapBlockBuilder;

    protected var _blocks:Vector.<IMapBlock>;

    protected var _bigObjects:Array = new Array()

    private var _lowerBigObjects:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;

    private var _higherBigObjects:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;

    private var _decorations:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;

    protected var _width:uint;

    protected var _height:uint;

    protected var _spawns:Array = new Array();

    private var _explosionPrints:ArrayList = new ArrayList();

    protected var _shadows:Array = new Array()

    protected var _blockDestroyed:Signal = new Signal(int, int, MapBlockType)

    public function MapBase() {
    }

    public function getBlock(x:uint, y:uint):IMapBlock {
        if (!areCoordsOk(x, y))
            throw new ArgumentError("One of indexes is out of range.");
        return _blocks[index(x, y)];
    }

    private function areCoordsOk(x:uint, y:uint):Boolean {
        return !(x >= width || y >= height || x < 0 || y < 0);
    }

    protected function getBO(id:int):BigObjectBase {
        return _bigObjects[id]
    }

    protected function index(x:int, y:int):int {
        return  y * width + x;
    }

    public function getNeighbour(ofX:int, ofY:int, to:Direction):IMapBlock {
        if (!areCoordsOk(ofX, ofY))
            return blockBuilder.make(0, 0, MapBlockType.NULL);
        switch (to) {
            case Direction.LEFT:
                return getLeft(ofX, ofY);
            case Direction.RIGHT:
                return getRight(ofX, ofY);
            case Direction.UP:
                return getUp(ofX, ofY);
            case Direction.DOWN:
                return getDown(ofX, ofY);
        }
        throw new ArgumentError("Invalid neighbour direction");
    }

    private function getLeft(ofX:int, ofY:int):IMapBlock {
        if (ofX == 0)
            return blockBuilder.make(0, 0, MapBlockType.NULL);
        return getBlock(ofX - 1, ofY);
    }

    private function getRight(ofX:int, ofY:int):IMapBlock {
        if (ofX == width - 1)
            return blockBuilder.make(0, 0, MapBlockType.NULL);
        return getBlock(ofX + 1, ofY);
    }

    private function getUp(ofX:int, ofY:int):IMapBlock {
        if (ofY == 0)
            return blockBuilder.make(0, 0, MapBlockType.NULL);
        return getBlock(ofX, ofY - 1);
    }

    private function getDown(ofX:int, ofY:int):IMapBlock {
        if (ofY == height - 1)
            return blockBuilder.make(0, 0, MapBlockType.NULL);
        return getBlock(ofX, ofY + 1);
    }

    public function get width():uint {
        return _width;
    }

    public function get height():uint {
        return _height;
    }

    public function get blockCount():uint {
        return _blocks.length;
    }

    public function get blocks():Vector.<IMapBlock> {
        return _blocks;
    }

    public function get spawns():Array {
        return _spawns;
    }

    public function validPoint(x:int, y:int):Boolean {
        return (x >= 0) && (y >= 0) && (x < width) && (y < height);
    }

    public function get explosionPrints():ArrayList {
        return _explosionPrints;
    }

    public function get lowerBigObjects():Vector.<BigObjectBase> {
        return _lowerBigObjects;
    }

    public function get higherBigObjects():Vector.<BigObjectBase> {
        return _higherBigObjects;
    }

    public function get decorations():Vector.<BigObjectBase> {
        return _decorations;
    }

    public function get shadows():Array {
        return _shadows
    }

    public function get bigObjects():Array {
        return _bigObjects
    }

    public function getRandomBlock(filter:Function):IMapBlock {
        var arr:Array = new Array()
        for (var i:int = 0; i < _blocks.length; i++) {
            var b:IMapBlock = _blocks[i];
            if (Boolean(filter(b))){
               arr.push(b)
            }
        }

        var ind:int = int(Math.random() * arr.length)
        return arr[ind]
    }

    public function get blockDestroyed():Signal {
        return _blockDestroyed;
    }
}
}
