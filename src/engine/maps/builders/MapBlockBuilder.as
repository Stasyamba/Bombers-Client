/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.builders {
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlock
import engine.maps.mapBlocks.MapBlockType

public class MapBlockBuilder {

    public var mapBlockStateBuilder:MapBlockStateBuilder;
    public var dynObjectBuilder:DynObjectBuilder;

    public function MapBlockBuilder(mapBlockTypeBuilder:MapBlockStateBuilder, dynObjectBuilder:DynObjectBuilder) {
        this.mapBlockStateBuilder = mapBlockTypeBuilder;
        this.dynObjectBuilder = dynObjectBuilder;
    }

    public function make(x:int, y:int, type:MapBlockType):IMapBlock {
        return new MapBlock(x, y, mapBlockStateBuilder.make(type), mapBlockStateBuilder, dynObjectBuilder);
    }
}
}