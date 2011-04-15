/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.maps.*
import engine.maps.builders.MapBlockBuilder
import engine.model.managers.interfaces.IMapManager

public class QuestMapManager implements IMapManager {

    private var _map:IMap;
    private var mapBlockBuilder:MapBlockBuilder;

    public function QuestMapManager(mapBlockBuilder:MapBlockBuilder) {
        this.mapBlockBuilder = mapBlockBuilder;
    }

    public function make(xml:XML):IMap {
        _map = new Map(xml, mapBlockBuilder);
        return _map;
    }

    public function setDieWall(x:int, y:int):void {
        _map.getBlock(x, y).setDieWall()
    }

    public function get canUseMap():Boolean {
        return _map != null
    }

    public function get map():IMap {
        return _map;
    }
}
}