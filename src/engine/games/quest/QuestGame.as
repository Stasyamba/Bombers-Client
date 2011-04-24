/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.quest {
import components.common.worlds.locations.LocationType

import engine.EngineContext
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.data.Consts
import engine.explosionss.ExplosionsBuilder
import engine.games.*
import engine.games.quest.goals.IGoal
import engine.games.quest.monsters.Monster
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.IWalkingStrategy
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.model.managers.quest.MonstersManager
import engine.model.managers.quest.QuestDOManager
import engine.model.managers.quest.QuestExplosionsManager
import engine.model.managers.regular.MapManager
import engine.model.managers.regular.PlayerManager
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.profiles.PlayerGameProfile
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IDeactivatableWeapon

import greensock.TweenMax

import mx.collections.ArrayList
import mx.controls.Alert

public class QuestGame extends GameBase implements IQuestGame {

    private var _goals:ArrayList = new ArrayList();
    private var _gameStats:GameStats = new GameStats();

    private var _gameId:String
    private var _questObject:QuestObject

    private var _monstersManager:MonstersManager

    public function QuestGame(gameId:String, quest:QuestObject) {
        super(LocationType.byValue(quest.locationId))
        _gameId = gameId

        mapBlockStateBuilder = new MapBlockStateBuilder();
        dynObjectBuilder = new DynObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, dynObjectBuilder)

        _mapManager = new MapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);


        _playerManager = new PlayerManager();
        _monstersManager = new MonstersManager();

        _explosionsManager = new QuestExplosionsManager(explosionsBuilder, mapManager, playerManager, monstersManager);
        _dynObjectManager = new QuestDOManager(playerManager, monstersManager, mapManager);
        weaponBuilder = new WeaponBuilder(_mapManager)
        playersBuilder = new PlayersBuilder(weaponBuilder)
        //game events
        Context.gameModel.gameStarted.addOnce(function():void {
            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(monstersManager.moveMonsters);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(dynObjectManager.checkObjectsActivated);

            EngineContext.triedToActivateWeapon.add(function (slot:int, x:int, y:int, type:WeaponType):void {
                EngineContext.weaponActivated.dispatch(slot, x, y, type);
            });
            EngineContext.weaponActivated.add(onWeaponUsed);

            EngineContext.objectActivated.add(onObjectTaken);

            EngineContext.objectAdded.add(onObjectAppeared)

            EngineContext.explosionGroupAdded.add(onExplosionsAdded)
            EngineContext.explosionsRemoved.add(onExplosionsRemoved)

            EngineContext.taskAccomplished.add(onTaskAccomplished)

            EngineContext.needToAddMonster.add(addMonster)
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

    private function onWeaponUsed(slot:int, x:int, y:int, type:WeaponType):void {
        var b:IBomber = getPlayer(slot);
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

    public function addPlayer(x:int, y:int, color:PlayerColor):void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        playerManager.setPlayer(playersBuilder.makePlayer(this, gp, new PlayerGameProfile(1, gp.currentBomberType, x, y, gp.aursTurnedOn), color));
    }

    public function addMonster(x:int, y:int, monsterType:MonsterType, slot:int = -1, walkingStrategy:IWalkingStrategy = null):void {
        var monster:Monster = playersBuilder.makeMonster(this,x,y, slot > 0 ? slot : monstersManager.getNewSlot(), monsterType, walkingStrategy)
        monstersManager.addMonster(monster)
        EngineContext.monsterAdded.dispatch(monster)
    }

    public function get type():GameType {
        return GameType.QUEST;
    }

    private function onMapLoaded(xml:XML):void {
        mapManager.make(xml);
        playerManager.me.putOnMap(mapManager.map, mapManager.map.spawns[0].x, mapManager.map.spawns[0].y);
        monstersManager.forEachAliveMonster(function(monster:Monster, slot:int):void {
            monster.putOnMap(mapManager.map, monster.startX, monster.startY)
        })
        mapManager.map.blockDestroyed.add(function(x:int, y:int, type:MapBlockType):void {
            gameStats.destroyedBlocks.addItem({type:type,x:x,y:y});
        })
        _ready = true;
    }

    public function get gameStats():GameStats {
        return _gameStats;
    }

    public function get location():LocationType {
        return _location
    }

    public function applyMapXml(map:XML):void {
        onMapLoaded(map);
    }

    public function get gameId():String {
        return _gameId
    }

    public function getPlayer(slot:int):IBomber {
        if (slot == playerManager.mySlot)
            return playerManager.me;
        return monstersManager.getMonsterBySlot(slot);
    }

    public function get monstersManager():MonstersManager {
        return _monstersManager
    }

    public function get questObject():QuestObject {
        return _questObject
    }
}
}









