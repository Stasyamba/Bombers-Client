/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import com.smartfoxserver.v2.entities.User

import engine.EngineContext
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IGameSkills
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
import engine.profiles.GameProfile
import engine.profiles.interfaces.IGameProfile
import engine.utils.Direction
import engine.weapons.AtomBombWeapon
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
        playersBuilder = new PlayersBuilder(bombsBuilder);

        _playerManager = new PlayerManager();
        _enemiesManager = new EnemiesManager();

        _bombsManager = new BombsManager(mapManager);
        _explosionsManager = new ExplosionsManager(explosionsBuilder, mapManager, playerManager, enemiesManager);
        _objectManager = new MapObjectManager(playerManager, mapManager)
         weaponBuilder = new WeaponBuilder(bombsBuilder,_mapManager,mapObjectBuilder,objectManager)
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

    public function addPlayer(user:User, color:PlayerColor):void {
        //todo:here player's profile will be taken as user variable
        var profile:IGameProfile = new GameProfile();
        var gameSkills:IGameSkills = profile.getGameSkills();
        var gameSkin:BomberSkin = profile.getSkin(user.playerId);
        if (user.isItMe) {

            //todo:make a weaponBuilder
            var player:IPlayerBomber = playersBuilder.makePlayer(this, user.playerId, user.name, color, gameSkills, weaponBuilder.makeSpecialBomb(3,WeaponType.ATOM_BOMB_WEAPON), gameSkin);
            playerManager.setPlayer(player);
        } else {
            //todo: here get profile from user variables and use it to make enemy
            var enemy:IEnemyBomber = playersBuilder.makeEnemy(this, user.playerId, user.name, color, gameSkills, weaponBuilder.makeSpecialBomb(3,WeaponType.ATOM_BOMB_WEAPON), gameSkin);
            enemiesManager.addEnemy(enemy);
        }
    }


    public function hasPlayer(playerId:int):Boolean {
        return playerManager.myId == playerId || enemiesManager.hasEnemy(playerId);
    }

    public function applyMap(mapId:String, spawnData:Array):void {
        var xml:XML = Maps.getXmlById(mapId);
        if (xml == null) {
            Context.gameModel.mapLoaded.addOnce(function (lXml:XML):void {
                onMapLoaded(lXml, spawnData);
            })
        } else {
            onMapLoaded(xml, spawnData)
        }
    }

    private function onMapLoaded(xml:XML, spawnData:Array):void {
        mapManager.make(xml);
        spawnData.forEach(
                         function setCoords(item:*, index:int, array:Array):void {

                             var bomber:IBomber = getPlayer(item.id);
                             if (bomber != null)
                                 bomber.putOnMap(mapManager.map, item.x, item.y);
                         })
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
        Context.gameServer.notifyPlayerDirectionChanged(x, y, dir, viewDirChanged)
    }

    private function onPlayerViewDirectionChanged(x:Number, y:Number, dir:Direction):void {
        Context.gameServer.notifyPlayerViewDirectionChanged(x, y, dir)
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
        Context.gameServer.notifyPlayerDamaged(damage, isDead);
    }

    //--------------getters and setters-----------------------
    public function get type():GameType {
        return GameType.REGULAR;
    }

}
}