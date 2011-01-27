/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.maps.*
import engine.maps.builders.MapBlockBuilder
import engine.model.managers.interfaces.IMapManager

public class SinglePlayerMapManager implements IMapManager {

    private var current:IMap;
    private var mapBlockBuilder:MapBlockBuilder;

    public function SinglePlayerMapManager(mapBlockBuilder:MapBlockBuilder) {
        this.mapBlockBuilder = mapBlockBuilder;
    }

    public function make(xml:XML):IMap {
        switch (String(xml.type)) {
            case "REGULAR":
                current = new Map(xml, mapBlockBuilder);
                return current;
        }
        throw new ArgumentError("Invalid XML map type");
    }

    public function get map():IMap {
        return current;
    }
}
}