/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.maps.*
import engine.maps.builders.MapBlockBuilder
import engine.model.managers.interfaces.IMapManager

public class MapManager implements IMapManager {

    private var _map:IMap;
    private var mapBlockBuilder:MapBlockBuilder;

    public function MapManager(mapBlockBuilder:MapBlockBuilder) {
        this.mapBlockBuilder = mapBlockBuilder;
    }

    public function make(xml:XML):IMap {
        switch (String(xml.type)) {
            case "REGULAR":
                _map = new Map(xml, mapBlockBuilder);
                return _map;
            case "SINGLE":
                _map = new Map(xml, mapBlockBuilder);
                return _map;
        }
        throw new ArgumentError("Invalid XML map type");
    }

    public function reset():void {
        _map = null;
    }

    public function get map():IMap {
        return _map;
    }

    public function setDieWall(x:int, y:int):void {
        _map.getBlock(x, y).setDieWall()
    }

    public function get canUseMap():Boolean {
        return _map != null;
    }
}
}