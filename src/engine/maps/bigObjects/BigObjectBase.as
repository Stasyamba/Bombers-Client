/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.DynObjectType

public class BigObjectBase {

    protected var _mapBlockStateBuilder:MapBlockStateBuilder;
    protected var _mapObjectBuilder:DynObjectBuilder;

    protected var _id:int
    private var _graphicsId:String

    protected var _x:int;
    protected var _y:int;
    protected var _width:int
    protected var _height:int

    private var _layer:BigObjectLayer

    protected var _blocks:Array = new Array();


    public function BigObjectBase(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder) {
        _id = xml.@id
        _graphicsId = xml.@graphicsId
        _x = xml.@x;
        _y = xml.@y;
        _width = xml.@width
        _height = xml.@height
        _layer = BigObjectLayer.fromString(String(xml.@layer))

        _mapBlockStateBuilder = mapBlockStateBuilder;
        _mapObjectBuilder = mapObjectBuilder;

        for each (var block:XML in xml.blocks.ObjectBlock) {
            var bl:IMapBlock = map.getBlock(_x + int(block.@x), _y + int(block.@y))
            _blocks.push(bl)

            var state:IMapBlockState = mapBlockStateBuilder.makeUnderObject(
                    block.@explodesAndStopsExplosion == "true",
                    block.@canGoThrough == "true",
                    block.@canExplosionGoThrough == "true",
                    block.@canSetBomb == "true",
                    String(block.@typeAfterObjectDestroyed) != "" ? MapBlockType.byKey(String(block.@typeAfterObjectDestroyed)) : MapBlockType.FREE,
                    String(block.@objectAfterObjectDestroyed) != "" ? DynObjectType.byKey(String(block.@objectAfterObjectDestroyed)) : DynObjectType.NULL,
                    block.@explodes == "true",
                    this);
            bl.setState(state);
        }
    }

    public function get id():int {
        return _id
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function get width():int {
        return _width
    }

    public function get height():int {
        return _height
    }

    public function get layer():BigObjectLayer {
        return _layer
    }

    public function get graphicsId():String {
        return _graphicsId
    }
}
}