/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.bombss.interfaces.IBomb
import engine.explosionss.ExplosionPoint
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.builders.MapObjectBuilder
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IBombsManager
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IObjectManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.MapManager

import mx.collections.ArrayList

public class GameBase {

    public function GameBase() {
    }

    //managers
    protected var _mapManager:MapManager;
    protected var _playerManager:IPlayerManager;
    protected var _enemiesManager:IEnemiesManager;
    protected var _bombsManager:IBombsManager;
    protected var _explosionsManager:IExplosionsManager;
    protected var _objectManager:IObjectManager;

    //builders
    public var bombsBuilder:BombsBuilder;
    public var explosionsBuilder:ExplosionsBuilder;
    public var mapBlockBuilder:MapBlockBuilder;
    public var mapObjectBuilder:MapObjectBuilder;
    public var mapBlockStateBuilder:MapBlockStateBuilder;
    public var playersBuilder:PlayersBuilder;

    public function get mapManager():IMapManager {
        return _mapManager;
    }

    public function get playerManager():IPlayerManager {
        return _playerManager;
    }

    public function get enemiesManager():IEnemiesManager {
        return _enemiesManager;
    }

    public function get bombsManager():IBombsManager {
        return _bombsManager;
    }

    public function get objectManager():IObjectManager {
        return _objectManager;
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

    protected function onBombSet(playerId:int, bombX:int, bombY:int, bombType:BombType):void {
        var owner:IBomber = getPlayer(playerId);
        var bomb:IBomb = bombsBuilder.makeBomb(bombType, mapManager.map.getBlock(bombX, bombY), owner)
        bomb.onSet();
        bombsManager.addBombAt(bombX, bombY, bomb);
    }

    protected function onBombExploded(bombX:int, bombY:int, power_bonus:int):void {
        bombsManager.explodeBombAt(bombX, bombY, power_bonus);
    }

    protected function onExplosionsRemoved(expls:ArrayList):void {
        for each (var e:IExplosion in expls.source)
            e.forEachPoint(function (point:ExplosionPoint):void {
                var b:IMapBlock = mapManager.map.getBlock(point.x, point.y);
                b.stopExplosion();
            })
    }

    protected function onExplosionsAdded(expls:ArrayList):void {
        explosionsManager.addExplosions(expls);
    }

    protected var _ready:Boolean = false;
    public function get ready():Boolean {
        return _ready;
    }


}
}