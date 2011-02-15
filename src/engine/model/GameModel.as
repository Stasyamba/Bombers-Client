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
import engine.model.signals.manage.PlayerReadyChangedSignal
import engine.model.signals.manage.ReadyToCreateGameSignal
import engine.model.signals.manage.ThreeSecondsToStartSignal
import engine.profiles.GameProfile
import engine.profiles.PlayerGameProfile
import engine.utils.greensock.TweenMax

import flash.events.TimerEvent
import flash.utils.Timer

import mx.controls.Alert

public class GameModel {


    private var gameBuilder:GameBuilder = new GameBuilder();

    //---signals
    public var connectedToGame:ReadyToCreateGameSignal = new ReadyToCreateGameSignal();

    public var playerReadyChanged:PlayerReadyChangedSignal = new PlayerReadyChangedSignal();
    public var threeSecondsToStart:ThreeSecondsToStartSignal = new ThreeSecondsToStartSignal();
    public var mapLoaded:MapLoadedSignal = new MapLoadedSignal();
    public var readyToCreateGame:ReadyToCreateGameSignal = new ReadyToCreateGameSignal();
    public var gameReady:GameReadySignal = new GameReadySignal();
    public var gameStarted:GameStartedSignal = new GameStartedSignal();

    public var gameEnded:GameEndedSignal = new GameEndedSignal();
    public var readyToPlayAgain:ReadyToPlayAgainSignal = new ReadyToPlayAgainSignal();


    private var tenSecondsTimer:Timer = new Timer(10000);

    private var _gameType:GameType;
    public var lobbyProfiles:Array
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
        //todo: here should be special login process
        Context.gameServer.login(Context.Model.currentSettings.socialProfile.id, Context.Model.currentSettings.socialProfile.id)
    }


    //----------singleplayer-----------

    public function createSinglePlayerGame(gameId:String):void {

        gameReady.addOnce(function():void {
            TweenMax.delayedCall(3, function():void {
                gameStarted.dispatch();
            })
        })

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

    public function tryCreateRegularGame(name:String, pass:String,locationId:int):void {
        Context.gameServer.createNewGameRequest(name,pass,locationId)
        Context.gameServer.someoneJoinedToGame.addOnce(onJoinedToGame)
        createdByMe = true;
    }

    public function leaveCurrentGame():void {
        Context.gameServer.leaveCurrentGame();
    }

    public function fastJoin(locationId:int = -1):void {
        Context.gameServer.fastJoinRequest(locationId);
        Context.gameServer.someoneJoinedToGame.addOnce(onJoinedToGame)
        Context.gameServer.fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
    }

    public function joinConcreteGame(name:String, pass:String):void {
        Context.gameServer.concreteJoinRequest(name,pass);
        Context.gameServer.someoneJoinedToGame.addOnce(onJoinedToGame)
        Context.gameServer.fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
    }

    public function setMeReady(ready:Boolean):void {
        Context.gameServer.setReadyRequest(ready);
    }

    private function startPing():void {
        tenSecondsTimer.addEventListener(TimerEvent.TIMER, onPing)
        tenSecondsTimer.start()
    }

    //--------------------------------HANDLERS--------------------------------

    private function onProfileLoaded(profile:GameProfile):void {
        Context.Model.currentSettings.gameProfile = profile
        Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)
    }


    private function onLoggedIn(name:String):void {
        Context.gameServer.joinDefaultRoom();
        startPing()
    }


    private function onPing(e:TimerEvent):void {
        Context.gameServer.ping();
    }

    private function onJoinedToGame():void {
        Context.gameServer.fastJoinFailed.removeAll()
        connectedToGame.dispatch();

        //todo:room variables must have vars describing gameType and map.
        _gameType = GameType.REGULAR;

        threeSecondsToStart.addOnce(onThreeSecondsToStart);
    }

    private function onFastJoinFailed():void {
        Context.gameServer.someoneJoinedToGame.remove(onJoinedToGame)
        connectedToGame.removeAll()
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
        gameEnded.addOnce(onGameEnded);
    }

    private function onGameEnded(/*parameters later*/):void {
        EngineContext.clear();
        setMeReady(false);
        readyToPlayAgain.addOnce(onReadyToPlayAgain)
    }

    private function onReadyToPlayAgain():void {
        EngineContext.clear();
        Context.game = null;
        threeSecondsToStart.addOnce(onThreeSecondsToStart);
    }

    // getters & setters
    public function get gameType():GameType {
        return _gameType;
    }


    public function set gameType(gameType:GameType):void {
        _gameType = gameType;
    }


}
}