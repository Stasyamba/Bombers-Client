/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.data.location1.mapObjects.BigObjects
import engine.maps.bigObjects.BigObject
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IBigObject
import engine.maps.interfaces.IBigObjectDescription
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.utils.Direction

import flash.geom.Point

import mx.collections.ArrayList
import mx.controls.Alert

import org.osflash.signals.Signal

public class Map implements IMap {

    public var blockBuilder:MapBlockBuilder;

    private var _blocks:Vector.<IMapBlock>;

    private var _lowerBigObjects:Vector.<IBigObject> = new Vector.<IBigObject>;
    private var _higherBigObjects:Vector.<IBigObject> = new Vector.<IBigObject>;
    private var _decorations:Vector.<IBigObject> = new Vector.<IBigObject>;


    private var _width:uint;
    private var _height:uint;
    private var _spawns:Array = new Array();

    private var _explosionPrints:ArrayList = new ArrayList();

    private var _blockDestroyed:Signal = new Signal(int, int, MapBlockType)

    //blockBuilder is injected via mapBuilder
    public function Map(xml:XML, blockBuilder:MapBlockBuilder) {
        this.blockBuilder = blockBuilder;
        fill(xml);
    }

    public function getBlock(x:uint, y:uint):IMapBlock {
        if (!areCoordsOk(x, y))
            throw new ArgumentError("One of indexes is out of range.");
        return _blocks[index(x, y)];
    }

    private function areCoordsOk(x:uint, y:uint):Boolean {
        return !(x >= width || y >= height || x < 0 || y < 0);
    }

    public function fill(xml:XML):void {

        _width = xml.size.@width;
        _height = xml.size.@height;

        _blocks = new Vector.<IMapBlock>(_width * _height, true);

        var y:int = 0;
        for each (var rowXml:XML in xml.rows.Row) {
            var rowStr:String = rowXml.@val;
            for (var x:int = 0; x < rowStr.length; x++) {
                try {
                    _blocks[index(x, y)] = blockBuilder.make(x, y, MapBlockType.fromChar(rowStr.charCodeAt(x)));
                    _blocks[index(x, y)].destroyed.add(function(x:int, y:int, type:MapBlockType):void {
                        _blockDestroyed.dispatch(x, y, type);
                    })
                } catch(er:ArgumentError) {
                    Alert.show("String contains bad symbols");
                }
            }
            y++;
        }

        //decorations
        for each (var bObj:XML in xml.decorations.Decoration) {
            var descr:IBigObjectDescription = BigObjects.objects[String(bObj.@id)] as IBigObjectDescription;
            var origin:Point = new Point(bObj.@x, bObj.@y);
            var blocksArr:Vector.<IMapBlock> = new Vector.<IMapBlock>();
            var bo:IBigObject = new BigObject(origin.x, origin.y, descr, blocksArr, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, true)
            decorations.push(bo);
        }
        //bigObjects
        for each (bObj in xml.bigObjects.BigObject) {
            descr = BigObjects.objects[String(bObj.@id)] as IBigObjectDescription;
            origin = new Point(bObj.@x, bObj.@y);
            blocksArr = new Vector.<IMapBlock>();
            for (var i:int = 0; i < descr.blocks.length; i++) {
                var obj:Object = descr.blocks[i]
                blocksArr.push(getBlock(origin.x + int(obj.x), origin.y + int(obj.y)));
            }
            //todo: BO builder
            bo = new BigObject(origin.x, origin.y, descr, blocksArr, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
            if (bObj.@layer == "higher")
                higherBigObjects.push(bo);
            else
                lowerBigObjects.push(bo);
        }
        for each (var spawn:XML in xml.spawns.Spawn) {
            _spawns.push({x:spawn.@x,y:spawn.@y})
        }
    }

    private function index(x:int, y:int):int {
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

    //getters
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

    public function get lowerBigObjects():Vector.<IBigObject> {
        return _lowerBigObjects;
    }

    public function get higherBigObjects():Vector.<IBigObject> {
        return _higherBigObjects;
    }

    public function get decorations():Vector.<IBigObject> {
        return _decorations;
    }

    public function get blockDestroyed():Signal {
        return _blockDestroyed;
    }
}
}