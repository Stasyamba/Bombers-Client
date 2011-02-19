/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model {
import com.smartfoxserver.v2.entities.User

import engine.EngineContext
import engine.games.GameBuilder
import engine.games.GameType
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
import engine.utils.greensock.TweenMax

import org.osflash.signals.Signal
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
    //not used now
    public var joinedToRoom:JoinedToRoomSignal = new JoinedToRoomSignal();
    public var joinedToGameRoom:JoinedToGameSignal = new JoinedToGameSignal();

    // fields
    private var _gameType:GameType;
    public var lobbyProfiles:Array
    public var lastGameLobbyProfiles:Array
    public var playerGameProfiles:Array
    public var createdByMe:Boolean


    function GameModel() {
    }

    //----------init-------------

    public function init():void {
        Context.gameServer.connected.add(onGameServerConnected);
        Context.gameServer.loggedIn.add(onLoggedIn);
        Context.gameServer.connectDefault();
        Context.gameServer.profileLoaded.add(onProfileLoaded);
    }

    private function onGameServerConnected():void {
        Context.gameServer.login(Context.Model.currentSettings.socialProfile.id, Context.Model.currentSettings.socialProfile.id)
        Context.gameServer.disconnected.removeAll()
        Context.gameServer.disconnected.addOnce(onServerDisconnected)
    }

    //----------singleplayer-----------

    public function createSinglePlayerGame(gameId:String):void {

        gameReady.addOnce(function():void {
            TweenMax.delayedCall(3, function():void {
                gameStarted.dispatch();
            })
        })
        _gameType = GameType.SINGLE
        createdByMe = true

        Context.game = gameBuilder.makeSinglePlayer(GameType.SINGLE, gameId);
        if (Context.game.ready) {
            gameReady.dispatch();
        } else {
            mapLoaded.addOnce(function(xml:XML):void {
                gameReady.dispatch();
            })
        }
    }


    //----------multiplayer-----------

    public function leaveCurrentGame():void {
        Context.gameServer.leaveCurrentGame();
        leftGame.dispatch();
    }

    public function tryCreateRegularGame(name:String, pass:String, locationId:int):void {
        Context.gameServer.createNewGameRequest(name, pass, locationId)
        someoneJoinedToGame.addOnce(onJoinedToGame)
        createGameFailed.addOnce(onFastJoinFailed)
        createdByMe = true;
        _gameType = GameType.REGULAR
    }

    public function fastJoin(locationId:int = -1):void {
        Context.gameServer.fastJoinRequest(locationId);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
        _gameType = GameType.REGULAR

    }

    public function joinConcreteGame(name:String, pass:String):void {
        Context.gameServer.concreteJoinRequest(name, pass);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
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
        if (profile.photoURL == "") {
            Context.gameServer.sendSetPhotoRequest(Context.Model.currentSettings.socialProfile.photoURL)
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
        EngineContext.clear()

        fastJoinFailed.removeAll()
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
        lobbyProfiles[lp.playerId] = null
    }

    private function onThreeSecondsToStart(data:Array, mapId:int):void {
        gameStarted.addOnce(onGameStarted)

        this.playerGameProfiles = new Array()
        for (var i:int = 0; i < data.length; i++) {
            var playerGP:PlayerGameProfile = data[i];
            this.playerGameProfiles[playerGP.playerId] = playerGP
        }
        Context.game = gameBuilder.makeRegular(mapId, playerGameProfiles);
        if (Context.game.ready) {
            gameReady.dispatch();
        } else {
            mapLoaded.addOnce(function(xml:XML):void {
                gameReady.dispatch();
            })
        }
    }

    private function onGameStarted():void {
        lastGameLobbyProfiles = lobbyProfiles.concat()
        for each (var lobbyProfile:LobbyProfile in lobbyProfiles) {
            if (lobbyProfile != null)
                lobbyProfile.isReady = false
        }
        gameEnded.addOnce(onGameEnded);
    }

    private function onGameEnded(p1:*, p2:*):void {
        EngineContext.clear();
        readyToPlayAgain.addOnce(onReadyToPlayAgain)
    }

    private function onReadyToPlayAgain():void {
        Context.game = null;
    }

    // getters & setters
    public function get gameType():GameType {
        return _gameType;
    }


}
}