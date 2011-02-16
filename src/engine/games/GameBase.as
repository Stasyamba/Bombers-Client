/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionPoint
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IDynObjectManager
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.MapManager
import engine.weapons.WeaponBuilder

import mx.collections.ArrayList

public class GameBase {

    public function GameBase() {
    }

    //managers
    protected var _mapManager:MapManager;
    protected var _playerManager:IPlayerManager;
    protected var _enemiesManager:IEnemiesManager;
    protected var _explosionsManager:IExplosionsManager;
    protected var _dynObjectManager:IDynObjectManager;

    //builders
    public var explosionsBuilder:ExplosionsBuilder;
    public var mapBlockBuilder:MapBlockBuilder;
    public var dynObjectBuilder:DynObjectBuilder;
    public var mapBlockStateBuilder:MapBlockStateBuilder;
    public var playersBuilder:PlayersBuilder;
    public var weaponBuilder:WeaponBuilder;

    private var _explosionExchangeBuffer:Array = new Array()

    protected var _ready:Boolean = false;

    public function get mapManager():IMapManager {
        return _mapManager;
    }

    public function get playerManager():IPlayerManager {
        return _playerManager;
    }

    public function get enemiesManager():IEnemiesManager {
        return _enemiesManager;
    }

    public function get dynObjectManager():IDynObjectManager {
        return _dynObjectManager;
    }

    public function get explosionsManager():IExplosionsManager {
        return _explosionsManager;
    }

    public function getPlayer(playerId:int):IBomber {
        if (playerId == playerManager.myId)
            return playerManager.me;
        return enemiesManager.getEnemyById(playerId);
    }

    //----------------Handlers---------------

    protected function onExplosionsRemoved(expls:ArrayList):void {
        for each (var e:IExplosion in expls.source)
            e.forEachPoint(function (point:ExplosionPoint):void {
                var b:IMapBlock = mapManager.map.getBlock(point.x, point.y);
                b.stopExplosion();
            })
    }

    protected function onExplosionsAdded(expls:Array):void {
        explosionsManager.addExplosions(expls);
    }


    public function get ready():Boolean {
        return _ready;
    }

    public function get explosionExchangeBuffer():Array {
        return _explosionExchangeBuffer
    }
}
}