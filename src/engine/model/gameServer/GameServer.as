/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.gameServer {
import com.smartfoxserver.v2.SmartFox
import com.smartfoxserver.v2.core.SFSEvent
import com.smartfoxserver.v2.entities.Room
import com.smartfoxserver.v2.entities.User
import com.smartfoxserver.v2.entities.data.ISFSObject
import com.smartfoxserver.v2.entities.data.SFSObject
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable
import com.smartfoxserver.v2.entities.variables.SFSUserVariable
import com.smartfoxserver.v2.entities.variables.VariableType
import com.smartfoxserver.v2.requests.ExtensionRequest
import com.smartfoxserver.v2.requests.JoinRoomRequest
import com.smartfoxserver.v2.requests.LeaveRoomRequest
import com.smartfoxserver.v2.requests.LoginRequest
import com.smartfoxserver.v2.requests.PublicMessageRequest
import com.smartfoxserver.v2.requests.RoomExtension
import com.smartfoxserver.v2.requests.SetRoomVariablesRequest
import com.smartfoxserver.v2.requests.SetUserVariablesRequest
import com.smartfoxserver.v2.requests.game.CreateSFSGameRequest
import com.smartfoxserver.v2.requests.game.QuickJoinGameRequest
import com.smartfoxserver.v2.requests.game.SFSGameSettings

import engine.EngineContext
import engine.bombss.BombType
import engine.games.GameType
import engine.maps.interfaces.IMapObject
import engine.maps.mapObjects.bonuses.BonusType
import engine.model.signals.InGameMessageReceivedSignal
import engine.model.signals.manage.GameAddedSignal
import engine.model.signals.manage.GameServerConnectedSignal
import engine.model.signals.manage.JoinedToGameSignal
import engine.model.signals.manage.JoinedToRoomSignal
import engine.model.signals.manage.LeftGameSignal
import engine.model.signals.manage.LoggedInSignal
import engine.model.signals.manage.RoomAddedSignal
import engine.model.signals.manage.SomeoneJoinedToGameSignal
import engine.model.signals.manage.SomeoneLeftGameSignal
import engine.profiles.GameProfile
import engine.utils.Direction

import flash.events.Event
import flash.events.TimerEvent
import flash.utils.Timer

import org.osflash.signals.Signal

public class GameServer extends SmartFox {

    //output
    private static const VIEW_DIRECTION_CHANGED:String = "view_direction_changed";
    private static const TRY_SET_BOMB:String = 'try_set_bomb';
    //input
    private static const GAME_STARTED:String = "game_started";
    private static const THREE_SECONDS_TO_START:String = "3_seconds_to_start";
    private static const BOMB_SET:String = 'set_bomb';
    private static const BOMB_EXPLODED:String = "bomb_exploded";
    private static const BONUS_APPEARED:String = "bonus_appeared";

    private static const DEATH_WALL_APPEARED:String = "death_wall_appeared";

    private static const PLAYER_DIED:String = "player_died";
    private static const GAME_ENDED:String = "game_ended";

    //bidirectional
    private static const INPUT_DIRECTION_CHANGED:String = "input_direction_changed";
    private static const PLAYER_DAMAGED:String = "player_damaged";
    private static const ACTIVATE_DYNAMIC_OBJECT:String = "activate_dynamic_object";
    private static const BONUS_TAKEN:String = "bonus_taken";
    private static const PING:String = "ping";
    private static const GAME_PROFILE_LOADED:String = "interface.gameProfileLoaded";

    public var ip:String;
    public var port:int;
    public var zone:String;
    public var defaultRoom:String;
    public var gameRoom:Room;

    public var connected:GameServerConnectedSignal = new GameServerConnectedSignal();
    public var loggedIn:LoggedInSignal = new LoggedInSignal();
    public var joinedToRoom:JoinedToRoomSignal = new JoinedToRoomSignal();
    public var roomAdded:RoomAddedSignal = new RoomAddedSignal();
    public var gameAdded:GameAddedSignal = new GameAddedSignal();
    public var joinedToGame:JoinedToGameSignal = new JoinedToGameSignal();
    public var someoneJoinedToGame:SomeoneJoinedToGameSignal = new SomeoneJoinedToGameSignal();
    public var someoneLeftGame:SomeoneLeftGameSignal = new SomeoneLeftGameSignal();
    public var leftGame:LeftGameSignal = new LeftGameSignal();

    public var roomCreationError:Signal = new Signal(String);
    public var inGameMessageReceived:InGameMessageReceivedSignal = new InGameMessageReceivedSignal();


    public function GameServer() {
        super(true)

        addEventListener(SFSEvent.CONNECTION, onConnected);

        addEventListener(SFSEvent.LOGIN, onLoggedIn);
        addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
        addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);

        addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnteredRoom);
        addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitedRoom);

        addEventListener(SFSEvent.ROOM_ADD, onRoomAdded);
        addEventListener(SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError);

        addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVariablesUpdated);
        addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

        addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessageRecieved);

        useDefaultLocalServerConfig()
    }


    private function IsRoomCurrentGame(room:Room):Boolean {
        return gameRoom != null && room.id == gameRoom.id
    }

    private function isUserInCurrentGame(user:User):Boolean {
        return gameRoom != null && user.isPlayerInRoom(gameRoom);
    }

    public function useDefaultLocalServerConfig():void {
        ip = 'cs1.vensella.ru';
        port = 9933;
        zone = 'bombers';
        defaultRoom = 'defRoom';
    }

    public function connectDefault():void {
        connect(ip, port);
    }

    public function login(withName:String,pass:String):void {
        send(new LoginRequest(withName, pass, zone));
    }

    public function joinDefaultRoom():void {
        send(new JoinRoomRequest(defaultRoom));
    }

    public function createGameRoom(name:String, pass:String, gameType:GameType):void {
        var settings:SFSGameSettings = new SFSGameSettings(name);
        settings.groupId = "games";
        settings.password = pass;
        settings.maxUsers = gameType.maxPlayers;
        settings.minPlayersToStartGame = gameType.minPlayers;
        settings.isPublic = true;
        settings.leaveLastJoinedRoom = false;
        settings.extension = new RoomExtension(gameType.extensionId, gameType.extensionClassName);

        send(new CreateSFSGameRequest(settings));
    }

    public function leaveCurrentGame():void {
        send(new LeaveRoomRequest());
        leftGame.dispatch();
    }

    public function quickJoinGame():void {
        send(new QuickJoinGameRequest(null, ["games"]));
    }

    public function setProfileVariable(profile:GameProfile):void {
        var vars:Array = [];
        vars.push(new SFSUserVariable("profile", SFSObject.newFromObject(profile), VariableType.OBJECT));
        send(new SetUserVariablesRequest(vars));

    }

    public function setRoomVars(gameType:GameType):void {
        var vars:Array = [];
        vars.push(new SFSRoomVariable("gameType", gameType.value, VariableType.STRING));
        send(new SetRoomVariablesRequest(vars, gameRoom));
    }

    public function sendInGameMessage(message:String):void {
        send(new PublicMessageRequest(message, null, gameRoom));
    }

    public function notifyPlayerReadyChanged(value:Boolean):void {
        var vars:Array = [];
        vars.push(new SFSUserVariable("ready", value, VariableType.BOOL));
        send(new SetUserVariablesRequest(vars));

        var params:ISFSObject = new SFSObject();
        params.putBool("is_ready", value);
        send(new ExtensionRequest("ready_changed", params, gameRoom));
    }

    public function notifyPlayerDirectionChanged(x:Number, y:Number, dir:Direction, viewDirectionChanged:Boolean):void {

        var params:ISFSObject = new SFSObject();
        params.putDouble("x", x);
        params.putDouble("y", y);
        params.putInt("dir", dir.value);
        params.putBool("view_direction_changed", viewDirectionChanged);

        send(new ExtensionRequest(INPUT_DIRECTION_CHANGED, params, gameRoom));
    }

    public function notifyPlayerViewDirectionChanged(x:Number, y:Number, dir:Direction):void {

        var params:ISFSObject = new SFSObject();
        params.putDouble("x", x);
        params.putDouble("y", y);
        params.putInt("dir", dir.value);

        send(new ExtensionRequest(VIEW_DIRECTION_CHANGED, params, gameRoom));
    }


    public function notifyTryingToSetBomb(bombX:int, bombY:int, type:BombType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("bomb_x", bombX);
        params.putInt("bomb_y", bombY);
        params.putInt("bomb_type", type.value);

        send(new ExtensionRequest(TRY_SET_BOMB, params, gameRoom));
    }

    public function notifyPlayerDamaged(damage:int, isDead:Boolean):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("damage", damage);
        params.putBool("is_dead", isDead);

        send(new ExtensionRequest(PLAYER_DAMAGED, params, gameRoom));
    }

    public function notifyActivateObject(object:IMapObject):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("x", object.x);
        params.putInt("y", object.y);

        send(new ExtensionRequest(ACTIVATE_DYNAMIC_OBJECT, params, gameRoom));
    }

    public function ping():void {
        var params:ISFSObject = new SFSObject();
        send(new ExtensionRequest(PING, params, gameRoom));
    }

    //----------------------Handlers---------------------------

    private function onConnected(event:SFSEvent):void {
        trace("connected successfully");
        connected.dispatch();
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace("Room joined successfully: " + room);

        if (room.isGame) {
            gameRoom = room;
            joinedToGame.dispatch()
        }
        else
            joinedToRoom.dispatch(room.id, room.name, room.userList)
    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace("Join Room failure: " + event.params.errorMessage)
    }

    private function onLoggedIn(event:SFSEvent):void {
        trace("logined successfully as: " + mySelf.name);
        loggedIn.dispatch(mySelf.name);
    }

    private function onLoginError(event:SFSEvent):void {
        trace("login failure: " + event.params.errorMessage)
    }

    private function onRoomAdded(event:SFSEvent):void {
        var room:Room = event.params.room;
        if (room.isGame) {
            trace("game added: " + room.name);
            gameRoom = room;
            gameAdded.dispatch();
        } else {
            trace("room added: " + room.name);
            roomAdded.dispatch(room.id, room.name);
        }
    }


    private function onRoomCreationError(event:SFSEvent):void {
        trace("room creation error: " + event.params.errorMessage);

        roomCreationError.dispatch(event.params.errorMessage);
    }


    private function onUserVariablesUpdated(event:SFSEvent):void {
        var user:User = event.params.user;

        var changedVars:Array = event.params.changedVars as Array;
        if (changedVars.indexOf("ready") != -1 && isUserInCurrentGame(user))
            Context.gameModel.playerReadyChanged.dispatch(user);
    }

    private function onUserEnteredRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(event.params.user.name + " entered room " + room.name);
        if (IsRoomCurrentGame(room)) {
            someoneJoinedToGame.dispatch(event.params.user);
        }
    }

    private function onUserExitedRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(event.params.user.name + " left room " + room.name);
        if (IsRoomCurrentGame(room)) {
            someoneLeftGame.dispatch(event.params.user);
        }
    }

    private function onPublicMessageRecieved(event:SFSEvent):void {
        if (event.params.room == gameRoom) {
            inGameMessageReceived.dispatch(event.params.sender, event.params.message);
        }
    }


    private function onExtensionResponse(event:SFSEvent):void {
        var responseParams:ISFSObject = event.params.params as SFSObject;
        switch (event.params.cmd) {
            case INPUT_DIRECTION_CHANGED:
                var user:User = userManager.getUserById(responseParams.getInt("user_id"));
                if (user.isItMe)
                    return;
                EngineContext.enemyInputDirectionChanged.dispatch(
                        user.playerId,
                        responseParams.getDouble("x"),
                        responseParams.getDouble("y"),
                        Direction.byValue(responseParams.getInt("dir")));
                break;
            case THREE_SECONDS_TO_START:
                //move this shit to model
                var data:Array = new Array();
                var i:int = 1;
                while (true) {
                    var uId:int = responseParams.getInt("user" + i.toString());
                    if (uId <= 0)
                        break;
                    user = userManager.getUserById(uId);
                    data.push({id:user.playerId,
                        x:responseParams.getInt("start_x" + i),
                        y:responseParams.getInt("start_y" + i)})
                    i++;
                }
                var mapId:int = responseParams.getInt("map_id");
                Context.gameModel.threeSecondsToStart.dispatch(data, mapId);
                break;
            case GAME_STARTED:
                Context.gameModel.gameStarted.dispatch();
                break;
            case BOMB_SET:
                //userId
                user = userManager.getUserById(responseParams.getInt("bomb_owner"));
                EngineContext.bombSet.dispatch(
                        user.playerId,
                        responseParams.getInt("bomb_x"),
                        responseParams.getInt("bomb_y"),
                        BombType.byValue(responseParams.getInt("bomb_type"))
                        );
                break;
            case BOMB_EXPLODED:
                EngineContext.bombExploded.dispatch(responseParams.getInt("bomb_x"),
                        responseParams.getInt("bomb_y"),
                        responseParams.getInt("bomb_power_bonus")
                        )
                break;
            case PLAYER_DAMAGED:
                user = userManager.getUserById(responseParams.getInt("user_id"));
                if (user.isItMe)
                    return;
                EngineContext.enemyDamaged.dispatch(user.playerId, responseParams.getInt("health_left"));
                break;
            case PLAYER_DIED:
                user = userManager.getUserById(responseParams.getInt("user_id"));
                if (user.isItMe)
                    return;
                EngineContext.enemyDied.dispatch(user.playerId);
                break;
            case BONUS_APPEARED:
                EngineContext.objectAppeared.dispatch(
                        responseParams.getInt("bonus_x"),
                        responseParams.getInt("bonus_y"),
                        BonusType.byValue(responseParams.getInt("bonus_type")))
                break;
            case BONUS_TAKEN:
                user = userManager.getUserById(responseParams.getInt("user_id"));
                EngineContext.objectTaken.dispatch(
                        user.playerId,
                        responseParams.getInt("bonus_x"),
                        responseParams.getInt("bonus_y"),
                        BonusType.byValue(responseParams.getInt("bonus_type")))
                break;
            case DEATH_WALL_APPEARED:
                trace("death wall " + responseParams.getInt("x") + "," + responseParams.getInt("y"))
                EngineContext.deathWallAppeared.dispatch(
                        responseParams.getInt("x"),
                        responseParams.getInt("y"))
                break;
            case GAME_ENDED:
                //get statistics here
                var timer:Timer = new Timer(3000, 1);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:Event):void {
                    Context.gameModel.gameEnded.dispatch();
                })
                timer.start();
                break;
            case GAME_PROFILE_LOADED:
                    trace("profile recieved !!!!!!!!!!!!!!!!!!!!");
                var gp : GameProfile = GameProfile.fromISFSObject(responseParams);
                //profileLoaded.dispatch(gp);
        }

    }

    public function get amIReady():Boolean {
        return mySelf.getVariable("ready").getBoolValue();
    }


}
}