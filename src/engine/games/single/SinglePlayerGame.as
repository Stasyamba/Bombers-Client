/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.single {
import com.smartfoxserver.v2.entities.User

import components.common.bombers.BomberType

import engine.EngineContext
import engine.bombers.PlayersBuilder
import engine.bombers.bots.AlongRightWallWalkingStrategy
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.data.location1.maps.Maps
import engine.explosionss.ExplosionsBuilder
import engine.games.*
import engine.games.single.goals.IGoal
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.model.managers.regular.MapManager
import engine.model.managers.regular.PlayerManager
import engine.model.managers.singlePlayer.SPDynObjectManager
import engine.model.managers.singlePlayer.SinglePlayerEnemiesManager
import engine.model.managers.singlePlayer.SinglePlayerExplosionsManager
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.profiles.PlayerGameProfile
import engine.utils.greensock.TweenMax
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IDeactivatableWeapon

import mx.collections.ArrayList
import mx.controls.Alert

public class SinglePlayerGame extends GameBase implements ISinglePlayerGame {


    private var _goals:ArrayList = new ArrayList();
    private var _gameStats:GameStats = new GameStats();


    public function SinglePlayerGame() {

        mapBlockStateBuilder = new MapBlockStateBuilder();
        dynObjectBuilder = new DynObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, dynObjectBuilder)

        _mapManager = new MapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);


        _playerManager = new PlayerManager();
        _enemiesManager = new SinglePlayerEnemiesManager();

        _explosionsManager = new SinglePlayerExplosionsManager(explosionsBuilder, mapManager, playerManager, enemiesManager);
        _dynObjectManager = new SPDynObjectManager(playerManager, enemiesManager, mapManager);
        weaponBuilder = new WeaponBuilder(_mapManager)
        playersBuilder = new PlayersBuilder(weaponBuilder)
        //game events
        Context.gameModel.gameStarted.addOnce(function():void {
            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(enemiesManager.moveEnemies);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(dynObjectManager.checkObjectsActivated);

            EngineContext.triedToActivateWeapon.add(function (playerId:int, x:int, y:int, type:WeaponType):void {
                EngineContext.weaponActivated.dispatch(playerId, x, y, type);
            });
            EngineContext.weaponActivated.add(onWeaponUsed);

            EngineContext.objectActivated.add(onObjectTaken);

            EngineContext.objectAdded.add(onObjectAppeared)

            EngineContext.explosionGroupAdded.add(onExplosionsAdded)
            EngineContext.explosionsRemoved.add(onExplosionsRemoved)

            EngineContext.taskAccomplished.add(onTaskAccomplished)
        })

        //goals
        EngineContext.frameEntered.add(checkGoals);
    }

    private function onObjectAppeared(x:int, y:int, type:IDynObjectType):void {
        var b:IMapBlock = mapManager.map.getBlock(x, y);
        var object:IDynObject = dynObjectBuilder.make(type, b);
        b.setObject(object);
        dynObjectManager.addObject(object);
    }

    private function onObjectTaken(id:int, x:int, y:int, objType:IDynObjectType):void {
        var bomber:IBomber = getPlayer(id);
        dynObjectManager.activateObject(x, y, bomber);
    }

    private function onTaskAccomplished():void {
        Alert.show("task accomplished");
        Context.gameModel.gameEnded.dispatch();
    }

    private function checkGoals(a:int):Boolean {
        for each (var goal:IGoal in _goals.source) {
            if (!goal.check(this)) return false
        }
        EngineContext.taskAccomplished.dispatch()
        return true;
    }


    private function onWeaponUsed(playerId:int, x:int, y:int, type:WeaponType):void {
        var b:IBomber = getPlayer(playerId);
        //todo: govnocode!!!
        var bomber:IPlayerBomber = b as IPlayerBomber
        bomber.activateWeapon(x, y, type);
        if (bomber.currentWeapon is IDeactivatableWeapon) {
            var dw:IDeactivatableWeapon = IDeactivatableWeapon(bomber.currentWeapon)
            TweenMax.delayedCall(dw.duration / 1000, bomber.deactivateWeapon)
        }

    }

    public function addGoal(goal:IGoal):void {
        _goals.addItem(goal);
    }

    public function addPlayer(mySelf:User, color:PlayerColor):void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        playerManager.setPlayer(playersBuilder.makePlayer(this, gp, new PlayerGameProfile(1, gp.currentBomberType, 0, 0, gp.aursTurnedOn), color));
    }

    public function addBot(color:PlayerColor):void {
        enemiesManager.addEnemy(playersBuilder.makeEnemyBot(this, new PlayerGameProfile(enemiesManager.enemiesCount + 2, BomberType.R2D3, 0, 0, new Array()), "bot" + enemiesManager.enemiesCount, color, new AlongRightWallWalkingStrategy()))
    }


    public function get type():GameType {
        return GameType.SINGLE;
    }

    public function applyMap(mapId:String):void {
        var xml:XML = Maps.getXmlById(mapId);
        if (xml == null) { //need to load map
            Context.gameModel.mapLoaded.addOnce(onMapLoaded);
        } else {
            onMapLoaded(xml);
        }
    }

    private function onMapLoaded(xml:XML):void {
        mapManager.make(xml);
        playerManager.me.putOnMap(mapManager.map, mapManager.map.spawns[0].x, mapManager.map.spawns[0].y);
        enemiesManager.forEachAliveEnemy(function(enemy:IEnemyBomber, playerId:int):void {
            enemy.putOnMap(mapManager.map, mapManager.map.spawns[playerId - 1].x, mapManager.map.spawns[playerId - 1].y)
        })
        mapManager.map.blockDestroyed.add(function(x:int, y:int, type:MapBlockType):void {
            gameStats.destroyedBlocks.addItem({type:type,x:x,y:y});
        })
        _ready = true;
    }

    public function get gameStats():GameStats {
        return _gameStats;
    }
}
}









