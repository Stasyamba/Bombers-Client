/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import components.common.bombers.BomberType

import engine.EngineContext
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.skin.BomberSkin
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.data.location1.maps.Maps
import engine.explosionss.ExplosionsBuilder
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.builders.MapObjectBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.maps.interfaces.IMapObjectType
import engine.model.managers.regular.BombsManager
import engine.model.managers.regular.EnemiesManager
import engine.model.managers.regular.ExplosionsManager
import engine.model.managers.regular.MapManager
import engine.model.managers.regular.MapObjectManager
import engine.model.managers.regular.PlayerManager
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType

public class RegularGame extends GameBase implements IMultiPlayerGame {


    public function RegularGame() {

        mapBlockStateBuilder = new MapBlockStateBuilder();
        mapObjectBuilder = new MapObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, mapObjectBuilder)

        _mapManager = new MapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);
        bombsBuilder = new BombsBuilder(_mapManager, explosionsBuilder);


        _playerManager = new PlayerManager();
        _enemiesManager = new EnemiesManager();

        _bombsManager = new BombsManager(mapManager);
        _explosionsManager = new ExplosionsManager(explosionsBuilder, mapManager, playerManager, enemiesManager);
        _objectManager = new MapObjectManager(playerManager, mapManager)
        weaponBuilder = new WeaponBuilder(bombsBuilder, _mapManager, mapObjectBuilder, objectManager)
        playersBuilder = new PlayersBuilder(bombsBuilder,weaponBuilder);
        //game events
        Context.gameModel.gameStarted.addOnce(function():void {

            EngineContext.playerInputDirectionChanged.add(onPlayerInputDirectionChanged);
            EngineContext.playerViewDirectionChanged.add(onPlayerViewDirectionChanged)

            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(enemiesManager.moveEnemies);
            EngineContext.frameEntered.add(bombsManager.checkBombs);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(objectManager.checkObjectTaken);


            EngineContext.triedToSetBomb.add(onTriedToSetBomb);
            EngineContext.bombSet.add(onBombSet);

            EngineContext.bombExploded.add(onBombExploded);
            EngineContext.explosionsAdded.add(onExplosionsAdded)
            EngineContext.explosionsRemoved.add(onExplosionsRemoved)

            EngineContext.playerDamaged.add(onPlayerDamaged)

            EngineContext.objectAppeared.add(onObjectAppeared)
            EngineContext.triedToTakeObject.add(tryToTakeBonus)
            EngineContext.objectTaken.add(onObjectTaken);

            EngineContext.deathWallAppeared.add(onDeathWallAppeared)
        })

    }

    public function addPlayer(profile:PlayerGameProfile, color:PlayerColor):void {
        if (profile.playerId == Context.gameServer.myPlayerId) {
            var player:IPlayerBomber = playersBuilder.makePlayer(this,Context.Model.currentSettings.gameProfile,profile,color);
            playerManager.setPlayer(player);
        } else {
            var enemy:IEnemyBomber = playersBuilder.makeEnemy(this, Context.gameModel.lobbyProfiles[profile.playerId], profile, color);
            enemiesManager.addEnemy(enemy);
        }
    }


    public function hasPlayer(playerId:int):Boolean {
        return playerManager.myId == playerId || enemiesManager.hasEnemy(playerId);
    }

    public function applyMap(mapId:String, playerProfiles:Array):void {
        var xml:XML = Maps.getXmlById(mapId);
        if (xml == null) {
            Context.gameModel.mapLoaded.addOnce(function (lXml:XML):void {
                onMapLoaded(lXml, playerProfiles);
            })
        } else {
            onMapLoaded(xml, playerProfiles)
        }
    }

    private function onMapLoaded(xml:XML, playerProfiles:Array):void {
        mapManager.make(xml);
        for each (var item:PlayerGameProfile in playerProfiles) {
            var bomber:IBomber = getPlayer(item.playerId);
                    if (bomber != null)
                        bomber.putOnMap(mapManager.map, item.x, item.y);
        }
        _ready = true;
    }

    private function onDeathWallAppeared(x:int, y:int):void {
        mapManager.setDieWall(x, y);
        if (playerManager.checkPlayerMetDieWall(x, y)) {
            playerManager.killMe();
        }
    }

    public function get numberOfPlayers():int {
        return enemiesManager.enemiesCount + 1;
    }


    private function onPlayerInputDirectionChanged(x:Number, y:Number, dir:Direction, viewDirChanged:Boolean):void {
        Context.gameServer.sendPlayerDirectionChanged(x, y, dir, viewDirChanged)
    }

    private function onPlayerViewDirectionChanged(x:Number, y:Number, dir:Direction):void {
        //Context.gameServer.notifyPlayerViewDirectionChanged(x, y, dir)
    }

    public function onTriedToSetBomb(bombX:int, bombY:int, type:BombType):void {
        Context.gameServer.notifyTryingToSetBomb(bombX, bombY, type)
    }


    private function onObjectTaken(id:int, x:int, y:int, objType:IMapObjectType):void {
        var bomber:IBomber = getPlayer(id);
        objectManager.takeObject(x, y, bomber);
    }

    private function tryToTakeBonus(object:IMapObject):void {
        Context.gameServer.notifyActivateObject(object);
    }

    private function onObjectAppeared(x:int, y:int, objType:IMapObjectType):void {
        var b:IMapBlock = mapManager.map.getBlock(x, y);
        var object:IMapObject = mapObjectBuilder.make(objType, b);
        b.setObject(object);
        objectManager.addObject(object);
    }

    private function onPlayerDamaged(damage:int, isDead:Boolean):void {
        Context.gameServer.sendPlayerDamaged(damage, isDead);
    }

    //--------------getters and setters-----------------------
    public function get type():GameType {
        return GameType.REGULAR;
    }

}
}