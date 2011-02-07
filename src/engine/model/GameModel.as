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


    private var oneSecondTimer:Timer = new Timer(1000);

    private var _gameType:GameType;


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
        Context.gameServer.login(Context.Model.currentSettings.socialProfile.vkProfile.id, Context.Model.currentSettings.socialProfile.vkProfile.id)
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

    public function tryCreateRegularGame(name:String, pass:String):void {
        Context.gameServer.createGameRoom(name, pass, GameType.REGULAR);
        Context.gameServer.joinedToGame.addOnce(onJoinedToGame);
        Context.gameServer.joinedToGame.addOnce(onGameCreated);
        Context.gameServer.roomCreationError.addOnce(onRoomCreationError);
    }

    public function leaveCurrentGame():void {
        Context.gameServer.leaveCurrentGame();
    }

    public function quickJoin():void {
        Context.gameServer.quickJoinGame();
        Context.gameServer.joinedToGame.addOnce(onJoinedToGame)
    }

    public function setMeReady(ready:Boolean):void {
        Context.gameServer.notifyPlayerReadyChanged(ready);
    }

    private function startPing():void {
        oneSecondTimer.addEventListener(TimerEvent.TIMER, onPing)
        oneSecondTimer.start()
    }

    //--------------------------------HANDLERS--------------------------------

    //todo: set vars when creating via settings.variables
    private function onGameCreated():void {
        Context.gameServer.setRoomVars(GameType.REGULAR)
    }

    private function onRoomCreationError(message:String):void {
        Context.gameServer.joinedToGame.removeAll();
        Alert.show(message);
    }

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
        //todo: gameServer.setProfileVariable(profile);
        Context.gameServer.notifyPlayerReadyChanged(false);
        Context.gameServer.joinDefaultRoom();
    }


    private function onPing(e:TimerEvent):void {
        Context.gameServer.ping();
    }

    private function onJoinedToGame():void {
        connectedToGame.dispatch();
        Context.gameServer.roomCreationError.removeAll();

        //todo:room variables must have vars describing gameType and map.
        _gameType = GameType.REGULAR;

        TweenMax.delayedCall(5.0, startPing)

        threeSecondsToStart.addOnce(onThreeSecondsToStart);
    }

    private function onThreeSecondsToStart(data:Array, mapId:int):void {
        gameStarted.addOnce(onGameStarted)
        Context.game = gameBuilder.makeFromRoom(Context.gameServer.gameRoom, mapId, data);
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

    public function getUsersReadyState():Array {
        var result:Array = [];
        for each (var user:User in Context.gameServer.gameRoom.playerList) {
            var ready:Boolean = user.getVariable("ready").getBoolValue();
            result[user.playerId] = {userName:user.name,ready:ready};
        }
        return result;
    }

    public function getUserProfile(user:User):GameProfile {
        //todo: replace with real implementation
        return new GameProfile();
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