/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.quest {
import components.common.worlds.locations.LocationType

import engine.EngineContext
import engine.bombers.CreatureBase
import engine.bombers.PlayersBuilder
import engine.bombers.QuestPlayerBomber
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionsBuilder
import engine.games.*
import engine.games.quest.goals.CollectedDOObject
import engine.games.quest.goals.DefeatedMonsterObject
import engine.games.quest.goals.DestroyedMapBlockObject
import engine.games.quest.goals.IGoal
import engine.games.quest.medals.Medal
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
import engine.model.managers.quest.QuestMapManager
import engine.model.managers.quest.QuestPlayerManager
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.profiles.PlayerGameProfile
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IActivatableWeapon

import greensock.TweenMax

import mx.controls.Alert

public class QuestGame extends GameBase implements IQuestGame {

    private var _gameStats:GameStats = new GameStats();

    private var _gameId:String
    private var _questObject:QuestObject

    private var _monstersManager:MonstersManager
    private var _bronzeGoal:IGoal
    private var _silverGoal:IGoal
    private var _goldGoal:IGoal

    public function QuestGame(gameId:String, quest:QuestObject) {
        super(LocationType.byValue(quest.locationId))
        _gameId = gameId
        _questObject = quest

        mapBlockStateBuilder = new MapBlockStateBuilder();
        dynObjectBuilder = new DynObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, dynObjectBuilder)

        _mapManager = new QuestMapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);
        dynObjectBuilder.setExplosionsBuilder(explosionsBuilder)

        _playerManager = new QuestPlayerManager();
        _monstersManager = new MonstersManager(_playerManager);

        _explosionsManager = new QuestExplosionsManager(explosionsBuilder, mapManager, playerManager, monstersManager);
        _dynObjectManager = new QuestDOManager(playerManager, monstersManager, mapManager);
        weaponBuilder = new WeaponBuilder(_mapManager)
        playersBuilder = new PlayersBuilder(weaponBuilder)
        //game events
        Context.gameModel.questStarted.addOnce(function():void {

            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(monstersManager.moveMonsters);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(dynObjectManager.checkObjectsActivated);
            EngineContext.frameEntered.add(monstersManager.checkMonstersHitPlayer);
            EngineContext.frameEntered.add((playerManager as QuestPlayerManager).checkPlayerMetActiveBlock);

            EngineContext.qActivateWeapon.add(onWeaponUsed);

            EngineContext.qAddObject.add(addObject)
            EngineContext.qPlayerActivateObject.add(onPlayerActivateObject);
            EngineContext.qMonsterActivateObject.add(onMonsterActivateObject);

            EngineContext.qMonsterDied.add(onMonsterDied);

            EngineContext.explosionGroupAdded.add(onExplosionsAdded)
            EngineContext.explosionsRemoved.add(onExplosionsRemoved)


            EngineContext.qNeedToAddMonster.add(onNeedToAddMonster)

            //goals
            EngineContext.frameEntered.add(checkGoals);

            Context.gameModel.questCompleted.add(onQuestCompleted)

            EngineContext.playerDied.add(onPlayerDied)
            EngineContext.qTimeOut.add(onTimeOut)
            Context.gameModel.questFailed.addOnce(onQuestFailed)

            Context.gameModel.questEnded.addOnce(onEndedGE)
            Context.gameModel.leftQuest.addOnce(onEndedLG)

            if (questObject.timeLimit > 0) {
                TweenMax.delayedCall(questObject.timeLimit, EngineContext.qTimeOut.dispatch)
            }
        })


    }

    private function onTimeOut():void {
        Context.gameModel.questFailed.dispatch(QuestFailReason.TIME)
    }

    private function onQuestFailed(qfr:QuestFailReason):void {
        Alert.show(qfr.text);
        Context.gameModel.questEnded.dispatch(false, null)
    }

    private function onPlayerDied():void {
        Context.gameModel.questFailed.dispatch(QuestFailReason.DEATH)
    }


    private function onEndedGE(p1:*, p2:*):void {
        destroy()
        Context.gameModel.leftQuest.remove(onEndedLG)
    }

    private function destroy():void {
        EngineContext.frameEntered.remove(checkGoals);
        EngineContext.frameEntered.remove(playerManager.movePlayer);
        EngineContext.frameEntered.remove(monstersManager.moveMonsters);
        EngineContext.frameEntered.remove(explosionsManager.checkExplosions);
        EngineContext.frameEntered.remove(dynObjectManager.checkObjectsActivated);
        EngineContext.frameEntered.remove(monstersManager.checkMonstersHitPlayer);
        EngineContext.frameEntered.remove((playerManager as QuestPlayerManager).checkPlayerMetActiveBlock);
    }

    private function onEndedLG():void {
        destroy()
        Context.gameModel.questEnded.remove(onEndedGE)
    }

    private function onMonsterDied(m:Monster):void {
        gameStats.defeatedMonsters.addItem(new DefeatedMonsterObject(m.slot, m.monsterType))
    }

    public function addObject(slot:int, x:int, y:int, type:IDynObjectType):void {
        var b:IMapBlock = mapManager.map.getBlock(x, y);
        var player:IBomber = getPlayer(slot) as IBomber

        var object:IDynObject = dynObjectBuilder.make(type, b, player);
        b.setObject(object)

        if (type.waitToAdd > 0)
            TweenMax.delayedCall(type.waitToAdd, function():void {
                dynObjectManager.addObject(object);
            })
        else
            dynObjectManager.addObject(object);
    }

    private function onPlayerActivateObject(id:int, x:int, y:int, objType:IDynObjectType):void {
        var bomber:IBomber = getPlayer(id) as IBomber;
        dynObjectManager.activateObject(x, y, bomber);
        gameStats.collectedObjects.addItem(new CollectedDOObject(objType, x, y))
    }

    private function onMonsterActivateObject(id:int, x:int, y:int, objType:IDynObjectType):void {
        //now it does nothing
        throw new Error("for now monsters aren't allowed to activate objects")
    }

    private function onQuestCompleted(medal:Medal):void {
        Alert.show("task accomplished with medal " + medal.string);
        Context.gameModel.questEnded.dispatch(true, medal);
    }

    private function checkGoals(p0:int):Boolean {
        if (!Context.gameModel.isPlayingNow) return false;
        var m:Medal = null
        if (_bronzeGoal.check(this))
            m = Medal.BRONZE
        if (_silverGoal.check(this))
            m = Medal.SILVER
        if (_goldGoal.check(this))
            m = Medal.GOLD
        if (m != null) {
            Context.gameModel.isPlayingNow = false
            Context.gameModel.questCompleted.dispatch(m)
            return true;
        }
        return false
    }

    private function onWeaponUsed(slot:int, x:int, y:int, type:WeaponType):void {

        var b:QuestPlayerBomber = getPlayer(slot) as QuestPlayerBomber;
        if (b != null) {
            b.activateWeapon(x, y, type);
        } else {
            var w:IActivatableWeapon = _weaponsUsed[type.value]
            if (w != null) {
                w.qActivateStatic(x, y, b)
                return
            }
            w = weaponBuilder.fromWeaponType(type, 0) as IActivatableWeapon
            if (w == null)
                throw new Error("wrong weapon type " + type.key + ". IActivatable weapon expected")
            w.qActivateStatic(x, y, b)
            _weaponsUsed[type.value] = w
        }
    }

    public function addGoal(medal:Medal, goal:IGoal):void {
        if (goal == null || medal == null)
            throw new Error("goal or medal == null")
        trace(medal, Medal.BRONZE, Medal.SILVER, Medal.GOLD)
        switch (medal) {
            case Medal.BRONZE:
                _bronzeGoal = goal
                break
            case Medal.SILVER:
                _silverGoal = goal
                break
            case Medal.GOLD:
                _goldGoal = goal
                break
            default:
                throw new Error("no such medal: " + medal.value)
        }
    }

    public function addPlayer(x:int, y:int, color:PlayerColor):void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        playerManager.setPlayer(playersBuilder.makeQuestPlayer(this, gp, new PlayerGameProfile(1, gp.currentBomberType, x, y, gp.aursTurnedOn), color));
    }

    private function onNeedToAddMonster(monsterType:MonsterType, x:int, y:int, ws:IWalkingStrategy):void {
        addMonster(x, y, monsterType, ws)
    }


    public function addMonster(x:int, y:int, monsterType:MonsterType, walkingStrategy:IWalkingStrategy, slot:int = -1):void {
        var monster:Monster = playersBuilder.makeMonster(this, x, y, slot > 0 ? slot : monstersManager.getNewSlot(), monsterType, walkingStrategy)
        monster.putOnMap(mapManager.map, monster.startX, monster.startY)
        monstersManager.addMonster(monster)
        EngineContext.qMonsterAdded.dispatch(monster)
    }


    public function applyMapXml(map:XML):void {
        mapManager.make(map);
        playerManager.me.putOnMap(mapManager.map, mapManager.map.spawns[0].x, mapManager.map.spawns[0].y);
        monstersManager.forEachAliveMonster(function(monster:Monster, slot:int):void {
            monster.putOnMap(mapManager.map, monster.startX, monster.startY)
        })
        mapManager.map.blockDestroyed.add(function(x:int, y:int, type:MapBlockType):void {
            gameStats.destroyedBlocks.addItem(new DestroyedMapBlockObject(type, x, y));
        })
        _ready = true;
    }

    public function getPlayer(slot:int):CreatureBase {
        if (slot == playerManager.mySlot)
            return playerManager.me as CreatureBase;
        return monstersManager.getMonsterBySlot(slot);
    }

    public function get monstersManager():MonstersManager {
        return _monstersManager
    }

    public function get questObject():QuestObject {
        return _questObject
    }

    public function get type():GameType {
        return GameType.QUEST;
    }

    public function get gameStats():GameStats {
        return _gameStats;
    }

    public function get location():LocationType {
        return _location
    }

    public function get gameId():String {
        return _gameId
    }
}
}









