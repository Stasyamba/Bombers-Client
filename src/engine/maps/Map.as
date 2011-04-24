/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.games.quest.monsters.MonsterType
import engine.games.quest.spawns.MonsterSpawn
import engine.maps.bigObjects.ActivatedBigObject
import engine.maps.bigObjects.BigObjectActivator
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.BigObjectLayer
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.shadows.ShadowObject
import engine.shadows.ShadowShape
import engine.utils.Direction

import mx.collections.ArrayList
import mx.controls.Alert

import org.osflash.signals.Signal

public class Map implements IMap {

    public var blockBuilder:MapBlockBuilder;

    private var _blocks:Vector.<IMapBlock>;

    private var _bigObjects:Array = new Array()
    private var _lowerBigObjects:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;
    private var _higherBigObjects:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;
    private var _decorations:Vector.<BigObjectBase> = new Vector.<BigObjectBase>;


    private var _width:uint;
    private var _height:uint;
    private var _spawns:Array = new Array();
    private var _monsterSpawns:Array = new Array()

    private var _explosionPrints:ArrayList = new ArrayList();

    private var _blockDestroyed:Signal = new Signal(int, int, MapBlockType)
    private var _shadows:Array = new Array()

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
                    Alert.show("String contains bad symbol " + rowStr.charCodeAt(x));
                }
            }
            y++;
        }

        //bigObjects
        for each (var bObj:XML in xml.bigObjects.BigObject) {
            var bo:BigObjectBase;
            switch (String(bObj.@t)) {
                case "activator":
                    bo = new BigObjectActivator(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "activated":
                    bo = new ActivatedBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "simple":
                    bo = new SimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life)
                    break
            }
            _bigObjects[bo.id] = bo
            switch (bo.layer) {
                case BigObjectLayer.DECORATION:
                    decorations.push(bo)
                    break
                case BigObjectLayer.HIGHER:
                    higherBigObjects.push(bo);
                    break
                case BigObjectLayer.LOWER:
                    lowerBigObjects.push(bo);
                    break
                default:
                    throw new Error("impossible case")
            }
        }
        //resolve activators links
        for each (bObj in xml.bigObjects.BigObject) {
            var bo:BigObjectBase = getBO(bObj.@id)
            if (bo is BigObjectActivator) {
                var target:ActivatedBigObject = getBO(bObj.@target) as ActivatedBigObject
                if (target == null) {
                    throw new Error("couldn't find target with id = " + bObj.@target)
                }
                (bo as BigObjectActivator).setTarget(target)
            }
        }
        for each (var spawn:XML in xml.spawns.Spawn) {
            _spawns.push({x:spawn.@x,y:spawn.@y})
        }
        for each (var mSpawn:XML in xml.spawns.MonsterSpawn) {
            _monsterSpawns.push(new MonsterSpawn(mSpawn.@x, mSpawn.@y, MonsterType.byId(mSpawn.@monsterId), mSpawn.@freq, mSpawn.@start, mSpawn.@stop))
        }
        //shadows
        for each (var s:XML in xml.shadows.Shadow) {
            _shadows.push(new ShadowObject(s.@x, s.@y, s.@width, s.@height, ShadowShape.fromString(s.@shape)))
        }
    }

    private function getBO(id:int):BigObjectBase {
        return _bigObjects[id]
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

    public function get lowerBigObjects():Vector.<BigObjectBase> {
        return _lowerBigObjects;
    }

    public function get higherBigObjects():Vector.<BigObjectBase> {
        return _higherBigObjects;
    }

    public function get decorations():Vector.<BigObjectBase> {
        return _decorations;
    }

    public function get blockDestroyed():Signal {
        return _blockDestroyed;
    }

    public function get bigObjects():Array {
        return _bigObjects
    }

    public function get monsterSpawns():* {
        return _monsterSpawns
    }

    public function get shadows():Array {
        return _shadows
    }
}
}