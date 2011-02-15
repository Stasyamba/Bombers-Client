/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.gameServer {
import com.smartfoxserver.v2.SmartFox
import com.smartfoxserver.v2.core.SFSEvent
import com.smartfoxserver.v2.entities.Room
import com.smartfoxserver.v2.entities.User
import com.smartfoxserver.v2.entities.data.ISFSArray
import com.smartfoxserver.v2.entities.data.ISFSObject
import com.smartfoxserver.v2.entities.data.SFSObject
import com.smartfoxserver.v2.requests.ExtensionRequest
import com.smartfoxserver.v2.requests.JoinRoomRequest
import com.smartfoxserver.v2.requests.LeaveRoomRequest
import com.smartfoxserver.v2.requests.LoginRequest
import com.smartfoxserver.v2.requests.PublicMessageRequest

import components.common.bombers.BomberType
import components.common.items.ItemType
import components.common.resources.ResourcePrice

import engine.EngineContext
import engine.bombss.BombType
import engine.maps.interfaces.IMapObject
import engine.maps.interfaces.IMapObjectType
import engine.maps.mapObjects.MapObjectType
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.model.signals.InGameMessageReceivedSignal
import engine.model.signals.ProfileLoadedSignal
import engine.model.signals.manage.GameServerConnectedSignal
import engine.model.signals.manage.JoinedToGameSignal
import engine.model.signals.manage.JoinedToRoomSignal
import engine.model.signals.manage.LeftGameSignal
import engine.model.signals.manage.LoggedInSignal
import engine.model.signals.manage.SomeoneJoinedToGameSignal
import engine.model.signals.manage.SomeoneLeftGameSignal
import engine.profiles.GameProfile
import engine.profiles.LobbyProfile
import engine.profiles.PlayerGameProfile
import engine.utils.Direction
import engine.utils.greensock.TweenMax
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class GameServer extends SmartFox {

    //output
    private static const VIEW_DIRECTION_CHANGED:String = "view_direction_changed";
    //input
    private static const GAME_STARTED:String = "game.lobby.gameStarted";
    private static const THREE_SECONDS_TO_START:String = "game.lobby.3SecondsToStart";
    private static const DYNAMIC_OBJECT_ADDED:String = 'game.DOAdd';
    private static const ACTIVATE_DYNAMIC_OBJECT:String = "game.actDO"
    private static const DYNAMIC_OBJECT_ACTIVATED:String = "game.DOAct";

    private static const DEATH_WALL_APPEARED:String = "game.deathWallAppeared";

    private static const PLAYER_DIED:String = "game.playerDied";
    private static const GAME_ENDED:String = "game.gameEnded";

    //bidirectional
    private static const INPUT_DIRECTION_CHANGED:String = "game.IDC";
    private static const PLAYER_DAMAGED:String = "game.playerDamaged";
    private static const DAMAGE_PLAYER:String = "game.damagePlayer"
    private static const ACTIVATE_WEAPON:String = "game.AW";
    private static const WEAPON_ACTIVATED:String = "game.WA";
    private static const WEAPON_DEACTIVATED:String = "game.WDA";
    private static const PING:String = "ping";

    //interface
    private static const INT_GAME_PROFILE_LOADED:String = "interface.gameProfileLoaded";
    private static const INT_BUY_RESOURCES:String = "interface.buyResources"
    private static const INT_BUY_RESOURCES_RESULT:String = "interface.buyResources.result"
    private static const INT_BUY_ITEM:String = "interface.buyItem";
    private static const INT_BUY_ITEM_RESULT:String = "interface.buyItem.result";
    private static const INT_GAME_NAME_RESULT:String = "interface.gameManager.findGameName.result"
    private static const INT_GAME_NAME:String = "interface.gameManager.findGameName"
    private static const INT_FAST_JOIN:String = "interface.gameManager.fastJoin"
    private static const INT_FAST_JOIN_RESULT:String = "interface.gameManager.fastJoin.result"
    private static const INT_CREATE_GAME:String = "interface.gameManager.createGame"
    private static const INT_CREATE_GAME_RESULT:String = "interface.gameManager.createGame.result"
    private static const LOBBY_PROFILES:String = "game.lobby.playersProfiles"
    private static const LOBBY_READY:String = "game.lobby.readyChanged"


    public var ip:String;
    public var port:int;
    public var zone:String;
    public var defaultRoom:String;
    public var gameRoom:Room;

    public var connected:GameServerConnectedSignal = new GameServerConnectedSignal();
    public var loggedIn:LoggedInSignal = new LoggedInSignal();

    public var profileLoaded:ProfileLoadedSignal = new ProfileLoadedSignal();

    public var fastJoinFailed:Signal = new Signal();

    public var joinedToRoom:JoinedToRoomSignal = new JoinedToRoomSignal();
    public var joinedToGame:JoinedToGameSignal = new JoinedToGameSignal();
    public var someoneJoinedToGame:SomeoneJoinedToGameSignal = new SomeoneJoinedToGameSignal();
    public var someoneLeftGame:SomeoneLeftGameSignal = new SomeoneLeftGameSignal();
    public var leftGame:LeftGameSignal = new LeftGameSignal();

    public var inGameMessageReceived:InGameMessageReceivedSignal = new InGameMessageReceivedSignal();
    public var newGameNameObtained:Signal = new Signal(String)


    public function GameServer() {
        super(true)

        addEventListener(SFSEvent.CONNECTION, onConnected);

        addEventListener(SFSEvent.LOGIN, onLoggedIn);
        addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
        addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);

        //addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnteredRoom);
        addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitedRoom);

        //addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVariablesUpdated);
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

    public function login(withName:String, pass:String):void {
        send(new LoginRequest(withName, pass, zone));
    }

    public function joinDefaultRoom():void {
        send(new JoinRoomRequest(defaultRoom));
    }

    public function leaveCurrentGame():void {
        send(new LeaveRoomRequest(gameRoom));
        gameRoom = null;
        leftGame.dispatch();
    }

    public function fastJoinRequest(locationId:int = -1):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.fastJoin.fields.locationId", locationId);
        params.putUtfString("interface.gameManager.fastJoin.fields.gameName", "");
        params.putUtfString("interface.gameManager.fastJoin.fields.password", "");
        send(new ExtensionRequest(INT_FAST_JOIN, params, null));
    }

    public function newGameNameRequest():void {
        send(new ExtensionRequest(INT_GAME_NAME, null, null))
    }

    public function createNewGameRequest(name:String, pass:String, locationId:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.createGame.fields.locationId", locationId);
        params.putUtfString("interface.gameManager.createGame.fields.gameName", name);
        params.putUtfString("interface.gameManager.createGame.fields.password", pass);
        send(new ExtensionRequest(INT_CREATE_GAME, params, null))
    }

    public function concreteJoinRequest(name:String, pass:String):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.fastJoin.fields.locationId", -1);
        params.putUtfString("interface.gameManager.fastJoin.fields.gameName", name);
        params.putUtfString("interface.gameManager.fastJoin.fields.password", pass);
        send(new ExtensionRequest(INT_FAST_JOIN, params, null));
    }

    public function sendInGameMessage(message:String):void {
        send(new PublicMessageRequest(message, null, gameRoom));
    }

    public function setReadyRequest(value:Boolean):void {
        var params:ISFSObject = new SFSObject();
        params.putBool("game.lobby.userReady.fields.isReady", value);
        send(new ExtensionRequest("game.lobby.userReady", params, gameRoom));
    }

    public function sendPlayerDirectionChanged(x:Number, y:Number, dir:Direction, viewDirectionChanged:Boolean):void {

        var params:ISFSObject = new SFSObject();
        params.putInt("userId", mySelf.id)
        params.putDouble("x", x);
        params.putDouble("y", y);
        params.putInt("dir", dir.value);

        send(new ExtensionRequest(INPUT_DIRECTION_CHANGED, params, gameRoom));
    }

    public function notifyPlayerViewDirectionChanged(x:Number, y:Number, dir:Direction):void {

        var params:ISFSObject = new SFSObject();
        params.putDouble("x", x);
        params.putDouble("y", y);
        params.putInt("dir", dir.value);

        send(new ExtensionRequest(VIEW_DIRECTION_CHANGED, params, gameRoom));
    }


    public function sendSetBomb(bombX:int, bombY:int, type:BombType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.AW.f.x", bombX);
        params.putInt("game.AW.f.y", bombY);
        params.putInt("game.AW.f.t", type.value);

        send(new ExtensionRequest(ACTIVATE_WEAPON, params, gameRoom));
    }

    public function sendPlayerDamaged(damage:int, isDead:Boolean):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.damagePlayer.fields.damage", damage);
        params.putBool("game.damagePlayer.fields.isDead", isDead);

        send(new ExtensionRequest(DAMAGE_PLAYER, params, gameRoom));
    }

    public function sendActivateDynamicObject(object:IMapObject):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.actDO.f.x", object.x);
        params.putInt("game.actDO.f.y", object.y);

        send(new ExtensionRequest(ACTIVATE_DYNAMIC_OBJECT, params, gameRoom));
    }

    public function sendActivateWeapon(x:int, y:int, weaponType:WeaponType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.AW.f.x", x);
        params.putInt("game.AW.f.y", y);
        params.putInt("game.AW.f.t", weaponType.value);

        send(new ExtensionRequest(ACTIVATE_WEAPON, params, gameRoom));
    }


    public function buyResourcesRequest(rp:ResourcePrice):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyResources.fields.resourceType0", rp.gold.value)
        params.putInt("interface.buyResources.fields.resourceType1", rp.crystals.value)
        params.putInt("interface.buyResources.fields.resourceType2", rp.adamant.value)
        params.putInt("interface.buyResources.fields.resourceType3", rp.antimatter.value)
        params.putInt("interface.buyResources.fields.resourceType4", 0)

        send(new ExtensionRequest(INT_BUY_RESOURCES, params, null))
    }

    public function buyItemRequest(it:ItemType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyItem.fields.itemId", it.value)

        send(new ExtensionRequest(INT_BUY_ITEM, params, null))
    }

    public function ping():void {
        send(new ExtensionRequest(PING, null, null));
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
                var user:User = userManager.getUserById(responseParams.getInt("userId"));
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
                var playerGameData:Array = new Array();
                var sfsArr:ISFSArray = responseParams.getSFSArray("game.lobby.3SecondsToStart.fields.PlayerGameProfiles")
                for (var i:int = 0; i < sfsArr.size(); i++) {
                    var obj:ISFSObject = sfsArr.getSFSObject(i)
                    var x:int = obj.getInt("StartX")
                    var y:int = obj.getInt("StartY")
                    var name:String = obj.getUtfString("UserId")
                    var user:User = userManager.getUserByName(name)
                    var auras:Array = new Array()
                    var bType:BomberType = BomberType.byValue(obj.getInt("BomberId"))
                    var a1:WeaponType = WeaponType.byValue(obj.getInt("AuraOne"))
                    var a2:WeaponType = WeaponType.byValue(obj.getInt("AuraTwo"))
                    var a3:WeaponType = WeaponType.byValue(obj.getInt("AuraThree"))
                    if (a1 != WeaponType.NULL)
                        auras.push(a1)
                    if (a2 != WeaponType.NULL)
                        auras.push(a2)
                    if (a3 != WeaponType.NULL)
                        auras.push(a3)
                    playerGameData.push(new PlayerGameProfile(user.playerId, bType, x, y, auras))
                }
                var mapId:int = responseParams.getInt("game.lobby.3SecondsToStart.fields.MapId");
                Context.gameModel.threeSecondsToStart.dispatch(playerGameData, mapId);
                break;
            case GAME_STARTED:
                Context.gameModel.gameStarted.dispatch();
                break;
            case DYNAMIC_OBJECT_ADDED:
                var ot:IMapObjectType = MapObjectType.byValue(responseParams.getInt("game.DOAdd.f.type"))
                if (ot is BombType) {
                    user = userManager.getUserByName(responseParams.getUtfString("game.DOAdd.f.userId"));
                    EngineContext.bombSet.dispatch(
                            user.playerId,
                            responseParams.getInt("game.DOAdd.f.x"),
                            responseParams.getInt("game.DOAdd.f.y"),
                            ot as BombType)
                } else if (ot is BonusType) {
                    EngineContext.objectAppeared.dispatch(
                            -1,
                            responseParams.getInt("game.DOAdd.f.x"),
                            responseParams.getInt("game.DOAdd.f.y"),
                            ot as BonusType)
                } else if (ot is MineType) {
                    user = userManager.getUserByName(responseParams.getUtfString("game.DOAdd.f.userId"));
                    EngineContext.objectAppeared.dispatch(
                            user.playerId,
                            responseParams.getInt("game.DOAdd.f.x"),
                            responseParams.getInt("game.DOAdd.f.y"),
                            ot as MineType)
                }
                break;
            case DYNAMIC_OBJECT_ACTIVATED:
                user = userManager.getUserByName(responseParams.getUtfString("game.DOAct.f.userId"));
                var ot:IMapObjectType = MapObjectType.byValue(responseParams.getInt("game.DOAct.f.type"))
                if (ot is BombType) {
                    EngineContext.bombExploded.dispatch(responseParams.getInt("game.DOAct.f.x"),
                            responseParams.getInt("game.DOAct.f.y"),
                            responseParams.getInt("game.DOAct.f.s.power")
                            )
                } else if (ot is BonusType) {
                    EngineContext.objectTaken.dispatch(
                            user.playerId,
                            responseParams.getInt("game.DOAct.f.x"),
                            responseParams.getInt("game.DOAct.f.y"),
                            ot as BonusType)
                }  else if (ot is MineType) {
                    EngineContext.objectTaken.dispatch(
                            user.playerId,
                            responseParams.getInt("game.DOAct.f.x"),
                            responseParams.getInt("game.DOAct.f.y"),
                            ot as MineType)
                }
                break;
            case WEAPON_ACTIVATED:
                user = userManager.getUserByName(responseParams.getUtfString("game.WA.f.userId"));
                var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WA.f.type"))
                var x:int = responseParams.getInt("game.WA.f.x")
                var y:int = responseParams.getInt("game.WA.f.y")
                EngineContext.weaponActivated.dispatch(user.playerId, x, y, wt)
                break;
            case WEAPON_DEACTIVATED:
                user = userManager.getUserByName(responseParams.getUtfString("game.WDA.f.userId"));
                var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WDA.f.type"))
                EngineContext.weaponDeactivated.dispatch(user.playerId, wt)
                break;
            case PLAYER_DAMAGED:
                user = userManager.getUserByName(responseParams.getUtfString("UserId"));
                if (user.isItMe)
                    return;
                EngineContext.enemyDamaged.dispatch(user.playerId, responseParams.getInt("HealthLeft"));
                trace("damaged enemy " + responseParams.getInt("HealthLeft"))
                break;
            case PLAYER_DIED:
                user = userManager.getUserByName(responseParams.getUtfString("UserId"));
                if (user == null)
                    return
                if (user.isItMe)
                    return;
                EngineContext.enemyDied.dispatch(user.playerId);
                break;
            case DEATH_WALL_APPEARED:
                EngineContext.deathWallAppeared.dispatch(
                        responseParams.getInt("x"),
                        responseParams.getInt("y"))
                break;
            case GAME_ENDED:
                //get statistics here
                TweenMax.delayedCall(3.0, function ():void {
                    Context.gameModel.gameEnded.dispatch()
                })
                break;
            case INT_GAME_PROFILE_LOADED:
                var gp:GameProfile = GameProfile.fromISFSObject(responseParams);
                profileLoaded.dispatch(gp);
                break;
            case INT_BUY_RESOURCES_RESULT:
                trace("resources bought");
                var status:Boolean = responseParams.getBool("interface.buyResources.result.fields.status")
                if (!status) {
                    Context.Model.dispatchCustomEvent(ContextEvent.RS_BUY_FAILED)
                    return
                } else {
                    var en:int = responseParams.getInt("interface.buyResources.result.fields.resourceType4")
                    if (en == 0) {
                        var rp:ResourcePrice = new ResourcePrice(responseParams.getInt("interface.buyResources.result.fields.resourceType0"),
                                responseParams.getInt("interface.buyResources.result.fields.resourceType1"),
                                responseParams.getInt("interface.buyResources.result.fields.resourceType2"),
                                responseParams.getInt("interface.buyResources.result.fields.resourceType3"))
                        Context.Model.currentSettings.gameProfile.resources.add(rp);
                        Context.Model.dispatchCustomEvent(ContextEvent.RS_BUY_SUCCESS, rp)
                        Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)
                    } else {
                        Context.Model.currentSettings.gameProfile.energy += en;
                        Context.Model.dispatchCustomEvent(ContextEvent.EN_BUY_SUCCESS, en)
                        Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED)
                    }
                }
                break;
            case INT_BUY_ITEM_RESULT:
                trace("resources bought");
                status = responseParams.getBool("interface.buyItem.result.fields.status")
                if (!status) {
                    Context.Model.dispatchCustomEvent(ContextEvent.IT_BUY_FAILED)
                    return
                }
                var iType:ItemType = ItemType.byValue(responseParams.getInt("interface.buyItem.result.fields.itemId"))
                var count:int = responseParams.getInt("interface.buyItem.result.fields.count")
                rp = new ResourcePrice(responseParams.getInt("interface.buyItem.result.fields.itemCostResourceType0"),
                        responseParams.getInt("interface.buyItem.result.fields.itemCostResourceType1"),
                        responseParams.getInt("interface.buyItem.result.fields.itemCostResourceType2"),
                        responseParams.getInt("interface.buyItem.result.fields.itemCostResourceType3"))
                Context.Model.currentSettings.gameProfile.addItem(iType, count);
                Context.Model.currentSettings.gameProfile.resources.subscract(rp);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.IT_BUY_SUCCESS, {it:iType,count:count})
                Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
                break;
            case INT_GAME_NAME_RESULT:
                newGameNameObtained.dispatch(responseParams.getUtfString("interface.gameManager.findGameName.result.fields.gameName"))
                break;
            case INT_FAST_JOIN_RESULT:
                fastJoinFailed.dispatch()
                break;
            case LOBBY_PROFILES:
                var resultArray:Array = new Array();
                var arr:ISFSArray = responseParams.getSFSArray("profiles");
                for (var i:int = 0; i < arr.size(); i++) {
                    var item:ISFSObject = arr.getSFSObject(i);
                    var id:int = item.getInt("Id");
                    var name:String = String(id);
                    var user:User = userManager.getUserByName(name)
                    var exp:int = item.getInt("Experience");
                    var nick:String = item.getUtfString("Nick");
                    var photo:String = item.getUtfString("Photo");
                    var ready:Boolean = item.getBool("IsReady");
                    resultArray[user.playerId] = new LobbyProfile(id, nick, photo, exp, user.playerId, ready)
                }
                Context.gameModel.lobbyProfiles = resultArray;
                someoneJoinedToGame.dispatch();
                break;
            case LOBBY_READY:
                var ready:Boolean = responseParams.getBool("IsReady")
                var name:String = responseParams.getUtfString("Id");
                var user:User = userManager.getUserByName(name)
                if (user == null || user.playerId <= 0)
                    return
                var lp:LobbyProfile = Context.gameModel.lobbyProfiles[user.playerId]
                if (lp != null)
                    lp.isReady = ready;
                Context.gameModel.playerReadyChanged.dispatch();
        }
    }

    public function get myPlayerId():int {
        return mySelf.playerId;
    }


}
}