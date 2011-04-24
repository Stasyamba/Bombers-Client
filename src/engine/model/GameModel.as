/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model {
import components.common.items.ItemProfileObject
import components.common.items.categories.ItemCategory
import components.common.worlds.locations.LocationType

import engine.EngineContext
import engine.data.Consts
import engine.data.quests.Quests
import engine.games.GameBuilder
import engine.games.GameType
import engine.games.quest.QuestObject
import engine.model.signals.GameEndedSignal
import engine.model.signals.GameReadySignal
import engine.model.signals.MapLoadedSignal
import engine.model.signals.ReadyToPlayAgainSignal
import engine.model.signals.manage.GameStartedSignal
import engine.model.signals.manage.JoinedToGameSignal
import engine.model.signals.manage.JoinedToRoomSignal
import engine.model.signals.manage.LeftGameSignal
import engine.model.signals.manage.PlayerReadyChangedSignal
import engine.model.signals.manage.ReadyToCreateGameSignal
import engine.model.signals.manage.SomeoneJoinedToGameSignal
import engine.model.signals.manage.SomeoneLeftGameSignal
import engine.model.signals.manage.ThreeSecondsToStartSignal
import engine.profiles.GameProfile
import engine.profiles.LobbyProfile
import engine.profiles.PlayerGameProfile

import greensock.TweenMax
import greensock.loading.ImageLoader
import greensock.loading.LoaderMax
import greensock.loading.SWFLoader
import greensock.loading.XMLLoader

import loading.BombersContentLoader

import mx.collections.ArrayCollection

import org.osflash.signals.Signal

public class GameModel {


    private var gameBuilder:GameBuilder = new GameBuilder();

    //---signals
    public var fastJoinFailed:Signal = new Signal();
    public var createGameFailed:Signal = new Signal()
    public var someoneJoinedToGame:SomeoneJoinedToGameSignal = new SomeoneJoinedToGameSignal();
    public var someoneLeftGame:SomeoneLeftGameSignal = new SomeoneLeftGameSignal();
    public var leftGame:LeftGameSignal = new LeftGameSignal();

    public var playerReadyChanged:PlayerReadyChangedSignal = new PlayerReadyChangedSignal();

    public var threeSecondsToStart:ThreeSecondsToStartSignal = new ThreeSecondsToStartSignal();
    public var mapLoaded:MapLoadedSignal = new MapLoadedSignal();
    public var gameReady:GameReadySignal = new GameReadySignal();

    public var gameStarted:GameStartedSignal = new GameStartedSignal();
    public var gameEnded:GameEndedSignal = new GameEndedSignal();
    public var readyToPlayAgain:ReadyToPlayAgainSignal = new ReadyToPlayAgainSignal();


    public var readyToCreateGame:ReadyToCreateGameSignal = new ReadyToCreateGameSignal();

    //quest
    public var questGameCreated:Signal = new Signal()
    public var createQuestFailed:Signal = new Signal()

    //not used now
    public var joinedToRoom:JoinedToRoomSignal = new JoinedToRoomSignal();
    public var joinedToGameRoom:JoinedToGameSignal = new JoinedToGameSignal();

    // fields
    private var _currentLocation:LocationType
    private var _gameType:GameType;
    public var lobbyProfiles:Array
    public var lastGameLobbyProfiles:Array
    public var playerGameProfiles:Array
    public var createdByMe:Boolean

    public var gameName:String
    public var gamePass:String
    public var isPlayingNow:Boolean = false

    private var _quests:ArrayCollection = new ArrayCollection()

    function GameModel() {
    }

    //----------init-------------

    public function init():void {
        LoaderMax.activate([XMLLoader,SWFLoader,ImageLoader])
        BombersContentLoader.questsLoaded.add(fillQuests)
        BombersContentLoader.loadBombers()
        BombersContentLoader.loadQuests()
        BombersContentLoader.loadMonsters()

        BombersContentLoader.readyToUseAppView.addOnce(function() {
            BombersContentLoader.loadGraphics()

            Context.gameServer.connected.add(onGameServerConnected);
            Context.gameServer.loggedIn.add(onLoggedIn);
            Context.gameServer.connectDefault();
            Context.gameServer.profileLoaded.add(onProfileLoaded);
        })
    }

    private function fillQuests():void {
        for (var i:int = 0; i < Consts.LOCATIONS_COUNT; i++)
            _quests.addItem(new ArrayCollection())
        for each(var name:String in Quests.questsNames) {
            var xml:XML = Quests.questXml(name)
            var lId:int = xml.location;
            var q:QuestObject = new QuestObject(xml);
            (_quests[lId] as ArrayCollection).addItem(q)
        }
        //check
        for (var i:int = 0; i < _quests.length; i++) {
            var arr:ArrayCollection = _quests[i];
            for (var j:int = 0; j < arr.length; j++) {
                var qObj:QuestObject = arr[j];
                trace("quest " + qObj.name + " at loc " + i + ": " + qObj.description)
            }
        }
    }

    public function getQuestObject(id:String):QuestObject {
        var loc_id:int = id.substr(1, 2) as int
        for each (var q:QuestObject in _quests[loc_id]) {
            if (q.id == id)
                return q
        }
        throw new Error("no quest with loc_id = " + loc_id + " and id = " + id)
    }

    private function onGameServerConnected():void {
        Context.gameServer.login(Context.Model.currentSettings.socialProfile.id, Context.Model.currentSettings.flashVars.auth_key);//Context.Model.currentSettings.socialProfile.id)
        Context.gameServer.disconnected.removeAll()
        Context.gameServer.disconnected.addOnce(onServerDisconnected)
    }

    //----------singleplayer-----------

    public function tryCreateQuest(questId:String, locationType:LocationType):void {
        Context.gameServer.createQuestRequest(questId, locationType.value)
        questGameCreated.addOnce(onQuestCreated)
        createQuestFailed.addOnce(onCreateQuestFailed)
        createdByMe = true
        _gameType = GameType.QUEST
        _currentLocation = locationType

        //todo: imitation
        questGameCreated.dispatch(questId, 666)
    }

    public function createQuestGame(questId:String, gameId:String):void {

        gameReady.addOnce(function():void {
            TweenMax.delayedCall(3, function():void {
                gameStarted.dispatch();
            })
        })

        Context.game = gameBuilder.makeQuest(getQuestObject(questId), gameId);

    }


    //----------multiplayer-----------

    public function leaveCurrentGame():void {
        Context.gameServer.leaveCurrentGame();
        leftGame.dispatch();
    }

    public function tryCreateRegularGame(name:String, pass:String, location:LocationType):void {
        Context.gameServer.createNewGameRequest(name, pass, location.value)
        someoneJoinedToGame.addOnce(onJoinedToGame)
        createGameFailed.addOnce(onFastJoinFailed)
        createdByMe = true;
        gameName = name
        gamePass = pass
        _gameType = GameType.REGULAR
        _currentLocation = location
    }

    public function fastJoin(locationId:int = -1):void {
        Context.gameServer.fastJoinRequest(locationId);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
        _gameType = GameType.REGULAR
        if (locationId >= 0) {
            _currentLocation = LocationType.byValue(locationId)
        }
    }

    public function joinConcreteGame(name:String, pass:String):void {
        Context.gameServer.concreteJoinRequest(name, pass);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
        gameName = name
        gamePass = pass
        _gameType = GameType.REGULAR

    }

    public function cancelConnectingToGame():void {
        _gameType = null
        onLeftGame()
    }

    public function setMeReady(ready:Boolean):void {
        Context.gameServer.setReadyRequest(ready);
    }


    //--------------------------------HANDLERS--------------------------------

    private function onServerDisconnected():void {
        onLeftGame()
    }

    private function onProfileLoaded(profile:GameProfile):void {
        Context.Model.currentSettings.gameProfile = profile
        Context.Model.currentSettings.gameProfileLoaded = true;

        if (profile.photoURL == "") {
            if (
                    profile.id != "test1" &&
                            profile.id != "test2" &&
                            profile.id != "test3" &&
                            profile.id != "test4" &&
                            profile.id != "test5") {
                Context.gameServer.sendSetPhotoRequest(Context.Model.currentSettings.socialProfile.photoURL)
            }

            Context.Model.currentSettings.gameProfile.photoURL = Context.Model.currentSettings.socialProfile.photoURL
        }

        Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)

        Context.Model.dispatchCustomEvent(ContextEvent.SHOW_MAIN_PREALODER, false)
    }

    private function onLoggedIn(name:String):void {
        Context.gameServer.joinDefaultRoom();
    }

    private function onQuestCreated(questId:String, gameId:String):void {
        createQuestFailed.removeAll()
        questGameCreated.removeAll()
        leftGame.add(onLeftGame)
        if (readyToCreateQuest()) {
            createQuestGame(questId, gameId)
        } else {
            var taskSignal:Signal = new Signal()
            taskSignal.addOnce(function():void {
                createQuestGame(questId, gameId)
            })
            BombersContentLoader.addTask(taskSignal, [currentLocation.stringId,"bombers","common"])

        }
    }

    private function readyToCreateQuest():Boolean {
        return Context.imageService.isLoaded(currentLocation.stringId) && Context.imageService.isLoaded("common");
    }


    private function onCreateQuestFailed():void {
        questGameCreated.removeAll()
        createQuestFailed.removeAll()
        _gameType = null
        _currentLocation = null
    }

    private function onJoinedToGame(p1:*):void {
        fastJoinFailed.removeAll()

        someoneLeftGame.add(onSomeoneLeftGame)
        leftGame.add(onLeftGame)
        threeSecondsToStart.add(onThreeSecondsToStart);
    }

    private function onFastJoinFailed():void {
        someoneJoinedToGame.removeAll()
    }

    private function onLeftGame():void {
        isPlayingNow = false
        EngineContext.clear()

        fastJoinFailed.removeAll()
        createGameFailed.removeAll()
        createQuestFailed.removeAll()
        questGameCreated.removeAll()
        someoneJoinedToGame.removeAll()
        someoneLeftGame.removeAll()
        leftGame.removeAll()
        playerReadyChanged.removeAll()
        threeSecondsToStart.removeAll()
        mapLoaded.removeAll()
        gameReady.removeAll()
        gameStarted.removeAll()
        gameEnded.removeAll()
        readyToPlayAgain.removeAll()
    }

    private function onSomeoneLeftGame(lp:LobbyProfile):void {
        lobbyProfiles[lp.slot] = null
    }

    private function onThreeSecondsToStart(data:Array, mapId:int):void {
        gameStarted.addOnce(onGameStarted)

        this.playerGameProfiles = new Array()
        for (var i:int = 0; i < data.length; i++) {
            var playerGP:PlayerGameProfile = data[i];
            this.playerGameProfiles[playerGP.slot] = playerGP
        }
        Context.game = gameBuilder.makeRegular(mapId, currentLocation, playerGameProfiles);
        if (Context.game.ready) {
            gameReady.dispatch();
        } else {
            mapLoaded.addOnce(function(xml:XML):void {
                gameReady.dispatch();
            })
        }
    }

    private function onGameStarted():void {
        isPlayingNow = true
        lastGameLobbyProfiles = lobbyProfiles.concat()
        for each (var lobbyProfile:LobbyProfile in lobbyProfiles) {
            if (lobbyProfile != null)
                lobbyProfile.isReady = false
        }
        gameEnded.addOnce(onGameEnded);
    }

    private function onGameEnded(p1:*, p2:*):void {
        isPlayingNow = false
        EngineContext.clear();
        readyToPlayAgain.addOnce(onReadyToPlayAgain)
    }

    private function onReadyToPlayAgain():void {
        Context.game = null;
    }

    public function getLobbyProfileById(id:String):LobbyProfile {
        for each (var lp:LobbyProfile in lobbyProfiles) {
            if (lp != null && lp.id == id)
                return lp
        }
        return null
    }

    public function myLobbyProfile():LobbyProfile {
        return getLobbyProfileById(Context.Model.currentSettings.gameProfile.id)
    }

    public function increaseWeaponIndex():void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        if (gp.selectedWeaponLeftHand == null) {
            var newW:ItemProfileObject = getNextWeapon(-1)
            if (newW != null)
                gp.selectedWeaponLeftHand = newW
        } else {
            for (var i:int = 0; i < gp.gotItems.length; i++) {
                var obj:ItemProfileObject = gp.gotItems[i];
                if (obj.itemType == gp.selectedWeaponLeftHand.itemType) {
                    var newW:ItemProfileObject = getNextWeapon(i)
                    gp.selectedWeaponLeftHand = newW
                    break
                }
            }
        }
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_UPDATE_GAME_WEAPONS);
        EngineContext.currentWeaponChanged.dispatch()
    }

    private function getNextWeapon(from:int):ItemProfileObject {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile;
        for (var i:int = from + 1; i < gp.gotItems.length; i++) {
            var obj:ItemProfileObject = gp.gotItems[i];
            if (obj != null && Context.Model.itemsCategoryManager.getItemCategory(obj.itemType) == ItemCategory.WEAPON) {
                return obj
            }
        }
        for (var i:int = 0; i <= from; i++) {
            var obj:ItemProfileObject = gp.gotItems[i];
            if (obj != null && Context.Model.itemsCategoryManager.getItemCategory(obj.itemType) == ItemCategory.WEAPON) {
                return obj
            }
        }
        return null
    }

// getters & setters
    public function get gameType():GameType {
        return _gameType;
    }


    public function isMySlot(slot:int):Boolean {
        return lobbyProfiles[slot].id == Context.Model.currentSettings.gameProfile.id
    }

    public function get currentLocation():LocationType {
        return _currentLocation
    }

    public function set currentLocation(currentLocation:LocationType):void {
        _currentLocation = currentLocation
    }
}
}