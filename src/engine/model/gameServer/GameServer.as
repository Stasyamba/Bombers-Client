/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.gameServer {
import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.PublicMessageRequest;

import components.common.base.access.rules.levelrule.AccessLevelRule;
import components.common.base.expirance.ExperianceObject;
import components.common.base.market.ItemMarketObject;
import components.common.bombers.BomberType;
import components.common.items.ItemObject;
import components.common.items.ItemProfileObject;
import components.common.items.ItemType;
import components.common.resources.ResourceObject;
import components.common.resources.ResourcePrice;
import components.wall.chest.WallChest;

import engine.EngineContext;
import engine.maps.interfaces.IDynObject;
import engine.maps.interfaces.IDynObjectType;
import engine.maps.mapObjects.DynObjectType;
import engine.model.signals.InGameMessageReceivedSignal;
import engine.model.signals.ProfileLoadedSignal;
import engine.model.signals.manage.GameServerConnectedSignal;
import engine.model.signals.manage.LoggedInSignal;
import engine.profiles.GameProfile;
import engine.profiles.LobbyProfile;
import engine.profiles.PlayerGameProfile;
import engine.utils.Direction;
import engine.utils.greensock.TweenMax;
import engine.weapons.WeaponType;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.controls.Alert;

import org.osflash.signals.Signal;
import org.osmf.media.IMediaTrait;

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
    private static const INT_SET_PHOTO:String = "interface.setPhoto";
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
	private static const INT_TRY_LUCK:String = "interface.tryLuck"
	private static const INT_TRY_LUCK_RESULT:String = "interface.tryLuck.result"
	private static const INT_BUY_LUCK:String = "interface.buyLuck"
	private static const INT_BUY_LUCK_RESULT:String = "interface.buyLuck.result"
	private static const INT_TAKE_PRIZE:String = "interface.takePrize"
	private static const INT_TAKE_PRIZE_RESULT:String = "interface.takePrize.result"
		
    private static const LOBBY_PROFILES:String = "game.lobby.playersProfiles"
    private static const LOBBY_READY:String = "game.lobby.readyChanged"

	private static const ADMIN_RELOAD_MAPS: String = "admin.reloadMapManager";
	private static const ADMIN_RELOAD_PRICE: String = "admin.reloadPricelistManager";
		

    public var ip:String;
    public var port:int;
    public var zone:String;
    public var defaultRoom:String;
    public var gameRoom:Room;

    public var connected:GameServerConnectedSignal = new GameServerConnectedSignal();
    public var disconnected:Signal = new Signal()
    public var loggedIn:LoggedInSignal = new LoggedInSignal();
    public var loginError:Signal = new Signal()

    public var profileLoaded:ProfileLoadedSignal = new ProfileLoadedSignal();


    public var inGameMessageReceived:InGameMessageReceivedSignal = new InGameMessageReceivedSignal();
    public var newGameNameObtained:Signal = new Signal(String)

    private var startPingFlag:Boolean = true
    private var tenSecondsTimer:Timer = new Timer(10000);

    public function GameServer() {
        super(true)

        addEventListener(SFSEvent.CONNECTION, onConnected);
        addEventListener(SFSEvent.CONNECTION_LOST, onDisconnected)

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

    public function useDefaultLocalServerConfig():void {
        ip = 'cs1.vensella.ru';
        port = 9933;
        zone = 'bombers';
        defaultRoom = 'defRoom';
    }

    public function connectWall():void {
        ip = 'cs1.vensella.ru';
        port = 9933;
        zone = 'bombersWall';
        defaultRoom = 'wallRoom';
        connect(ip, port)
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

    public function sendSetPhotoRequest(photo:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.setPhoto.fields.photoUrl", photo);
        send(new ExtensionRequest(INT_SET_PHOTO, params, null));
    }

    public function leaveCurrentGame():void {
        send(new LeaveRoomRequest(gameRoom));
        gameRoom = null;

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
        params.putInt("slot", Context.gameModel.myLobbyProfile().slot)
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

    public function sendPlayerDamaged(damage:int, isDead:Boolean):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.damagePlayer.fields.damage", damage);
        params.putBool("game.damagePlayer.fields.isDead", isDead);

        send(new ExtensionRequest(DAMAGE_PLAYER, params, gameRoom));
    }

    public function sendActivateDynamicObject(object:IDynObject):void {
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

    public function sendChangeBomberRequest(type:BomberType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.setBomber.fields.bomberId", type.value);
        send(new ExtensionRequest("interface.setBomber", params, null));
    }

    public function sendBuyResourcesRequest(rp:ResourcePrice):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyResources.fields.resourceType0", rp.gold.value)
        params.putInt("interface.buyResources.fields.resourceType1", rp.crystals.value)
        params.putInt("interface.buyResources.fields.resourceType2", rp.adamant.value)
        params.putInt("interface.buyResources.fields.resourceType3", rp.antimatter.value)
        params.putInt("interface.buyResources.fields.resourceType4", 0)

        send(new ExtensionRequest(INT_BUY_RESOURCES, params, null))
    }

    public function sendBuyEnergyRequest(count:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyResources.fields.resourceType0", 0)
        params.putInt("interface.buyResources.fields.resourceType1", 0)
        params.putInt("interface.buyResources.fields.resourceType2", 0)
        params.putInt("interface.buyResources.fields.resourceType3", 0)
        params.putInt("interface.buyResources.fields.resourceType4", count)

        send(new ExtensionRequest(INT_BUY_RESOURCES, params, null))
    }

    public function sendBuyItemRequest(it:ItemType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyItem.fields.itemId", it.value)

        send(new ExtensionRequest(INT_BUY_ITEM, params, null))
    }

    public function sendDropItemRequest(itemType:ItemType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.dropItem.fields.itemId", itemType.value)

        send(new ExtensionRequest("interface.dropItem", params, null))
    }

    public function sendSaveNickRequest(name:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.setNick.fields.nick", name);
        send(new ExtensionRequest("interface.setNick", params, null));
    }

    public function wall_sendSubmitPrice(posterId: String):void {
		var params:ISFSObject = new SFSObject();
        params.putUtfString("PostCreatorId", posterId);
		
        send(new ExtensionRequest("bombersWall.submitPrize", params, null));
    }

    public function ping(e:*):void {
        send(new ExtensionRequest(PING, null, null));
    }

    private function startPing():void {
        tenSecondsTimer.addEventListener(TimerEvent.TIMER, ping)
        tenSecondsTimer.start()
    }

	public function tryLottery():void
	{
		var params:ISFSObject = new SFSObject();
		send(new ExtensionRequest(INT_TRY_LUCK, params, null));
	}
	
	public function buyLuck():void
	{
		var params:ISFSObject = new SFSObject();
		params.putInt("interface.buyLuck.fields.luck", 3);
		
		send(new ExtensionRequest(INT_BUY_LUCK, params, null));
	}
	
	public function takePrize():void
	{
		var params:ISFSObject = new SFSObject();
		send(new ExtensionRequest(INT_TAKE_PRIZE, params, null));
	}
	
	public function adminReloadMaps():void 
	{
		var params:ISFSObject = new SFSObject();
		send(new ExtensionRequest(ADMIN_RELOAD_MAPS, params, null));
	}
	
	public function adminReloadPrice():void 
	{
		var params:ISFSObject = new SFSObject();
		send(new ExtensionRequest(ADMIN_RELOAD_PRICE, params, null));
	}
	
    //----------------------Handlers---------------------------

    private function onConnected(event:SFSEvent):void {
        if (event.params.success) {
            trace("connected successfully");
            connected.dispatch();
        } else {
            Context.Model.dispatchCustomEvent(ContextEvent.NEED_TO_SHOW_CANT_CONNECT_WINDOW)
        }
    }

    private function onDisconnected(e:SFSEvent):void {
        disconnected.dispatch()
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;
        if (startPingFlag) {
            startPing()
            startPingFlag = false
        }
        trace("Room joined successfully: " + room);

        if (room.isGame) {
            gameRoom = room;
            Context.gameModel.joinedToGameRoom.dispatch()
        }
        else
            Context.gameModel.joinedToRoom.dispatch(room.id, room.name, room.userList)
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
        loginError.dispatch()
    }

    private function onUserExitedRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(event.params.user.name + " left room " + room.name);
        if (!IsRoomCurrentGame(room)) {
            return
        }
        var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(event.params.user.name)
        Context.gameModel.someoneLeftGame.dispatch(lp);
    }

    private function onPublicMessageRecieved(event:SFSEvent):void {
        if (event.params.room == gameRoom) {
            if (Context.gameModel.lobbyProfiles != null)
                if (Context.gameModel.getLobbyProfileById(event.params.sender.name) != null)
                    inGameMessageReceived.dispatch(Context.gameModel.getLobbyProfileById(event.params.sender.name), event.params.message);
        }
    }

    private function onExtensionResponse(event:SFSEvent):void {
        var responseParams:ISFSObject = event.params.params as SFSObject;
        switch (event.params.cmd) {
            case INPUT_DIRECTION_CHANGED:
                //special case, message is broadcasted
                var slot:int = responseParams.getInt("slot");
                if (Context.gameModel.isMySlot(slot))
                    return
                EngineContext.enemyInputDirectionChanged.dispatch(
                        slot,
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
                    var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(name)
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
                    playerGameData.push(new PlayerGameProfile(lp.slot, bType, x, y, auras))
                }
                var mapId:int = responseParams.getInt("game.lobby.3SecondsToStart.fields.MapId");
                Context.gameModel.threeSecondsToStart.dispatch(playerGameData, mapId);
                break;
            case GAME_STARTED:
                Context.gameModel.gameStarted.dispatch();
                break;
            case DYNAMIC_OBJECT_ADDED:
                slot = -1
                var ot:IDynObjectType = DynObjectType.byValue(responseParams.getInt("game.DOAdd.f.type"))
                name = responseParams.getUtfString("game.DOAdd.f.userId")
                if (name != null && name != "")
                    slot = Context.gameModel.getLobbyProfileById(name).slot
                EngineContext.objectAdded.dispatch(
                        slot,
                        responseParams.getInt("game.DOAdd.f.x"),
                        responseParams.getInt("game.DOAdd.f.y"),
                        ot)
                break
            case DYNAMIC_OBJECT_ACTIVATED:
                slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.DOAct.f.userId")).slot
                var ot:IDynObjectType = DynObjectType.byValue(responseParams.getInt("game.DOAct.f.type"))
                EngineContext.objectActivated.dispatch(
                        slot,
                        responseParams.getInt("game.DOAct.f.x"),
                        responseParams.getInt("game.DOAct.f.y"),
                        ot)
                break;
            case WEAPON_ACTIVATED:
                slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.WA.f.userId")).slot
                var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WA.f.type"))
                var x:int = responseParams.getInt("game.WA.f.x")
                var y:int = responseParams.getInt("game.WA.f.y")
                EngineContext.weaponActivated.dispatch(slot, x, y, wt)
                break;
            case WEAPON_DEACTIVATED:
                slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.WDA.f.userId")).slot
                var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WDA.f.type"))
                EngineContext.weaponDeactivated.dispatch(slot, wt)
                break;
            case PLAYER_DAMAGED:
                slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("UserId")).slot
                if (Context.gameModel.isMySlot(slot))
                    return;
                EngineContext.enemyDamaged.dispatch(slot, responseParams.getInt("HealthLeft"));
                trace("damaged enemy " + responseParams.getInt("HealthLeft"))
                break;
            case PLAYER_DIED:
                var slot:int
                var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("UserId"));
                if (lp != null) {
                    slot = lp.slot
                    if (Context.gameModel.isMySlot(slot)) {
                        updLobbyExperience(slot, responseParams.getInt("Rank"), responseParams.getInt("Experience"))
                        Context.Model.currentSettings.gameProfile.experience = responseParams.getInt("Experience")
                        return
                    }
                } else {
                    for each (var lobbyProfile:LobbyProfile in Context.gameModel.lastGameLobbyProfiles) {
                        if (lobbyProfile != null) {
                            if (lobbyProfile.id == responseParams.getUtfString("UserId")) {
                                slot = lobbyProfile.slot
                                break
                            }
                        }
                    }
                }
                updLobbyExperience(slot, responseParams.getInt("Rank"), responseParams.getInt("Experience"))
                EngineContext.enemyDied.dispatch(slot);
                break;
            case
            DEATH_WALL_APPEARED:
                EngineContext.deathWallAppeared.dispatch(
                        responseParams.getInt("x"),
                        responseParams.getInt("y"))
                break;
            case
            GAME_ENDED:
                var wId:String = responseParams.getUtfString("game.gameEnded.WinnerId")
                var wExp:int = responseParams.getInt("game.gameEnded.WinnerExperience")
                slot = Context.gameModel.getLobbyProfileById(wId).slot
                updLobbyExperience(slot, 1, wExp)
                if (Context.gameModel.isMySlot(slot)) {
                    Context.Model.currentSettings.gameProfile.experience = responseParams.getInt("game.gameEnded.WinnerExperience")
                }
                TweenMax.delayedCall(3.0, function ():void {
                    Context.gameModel.gameEnded.dispatch(wId, wExp)
                })
                var arr:ISFSArray = responseParams.getSFSArray("profiles");
                Context.gameModel.lobbyProfiles = getLobbyProfilesFromSFSArray(arr)
                break;
            case
            INT_GAME_PROFILE_LOADED:

                //resourceCost
                var plist:ISFSObject = responseParams.getSFSObject("Pricelist")

                Context.resourceMarket.GOLD_VOICES = plist.getInt("GoldCost")
                Context.resourceMarket.CRYSTAL_VOICES = plist.getInt("CrystalCost")
                Context.resourceMarket.ADAMANTIUM_VOICES = plist.getInt("AdamantiumCost")
                Context.resourceMarket.ANTIMATTER_VOICES = plist.getInt("AntimatterCost")
                var enArr:ISFSArray = plist.getSFSArray("EnergyCost")
                for (var i:int = 0; i < enArr.size(); i++) {
                    var it:ISFSObject = enArr.getSFSObject(i);
                    Context.resourceMarket.ENERGY_VOICES[it.getInt("Count")] = it.getInt("Price")
                }
                var discArr:ISFSArray = plist.getSFSArray("Discounts")
                var discs:Array = new Array()
                for (var i:int = 0; i < discArr.size(); i++) {
                    var it:ISFSObject = discArr.getSFSObject(i);
                    discs.push({moreThan:it.getInt("From"),discount:it.getInt("Value")})
                }
                Context.resourceMarket.setDiscounts(discs)
                //itemCost
                var itemsArr:ISFSArray = plist.getSFSArray("Items");
                var prices:Array = new Array()
                for (var i:int = 0; i < itemsArr.size(); i++) {
                    var obj:ISFSObject = itemsArr.getSFSObject(i);
                    var id:int = obj.getInt("Id")
                    var rp:ResourcePrice = new ResourcePrice(obj.getInt("Gold"), obj.getInt("Crystal"), obj.getInt("Adamantium"), obj.getInt("Antimatter"))
                    var stack:int = obj.getInt("Stack")
                    var so:Boolean = obj.getBool("SpecialOffer")
                    var imo:ItemMarketObject = new ItemMarketObject(rp, stack, so)
                    prices[id] = imo
                    var lev:int = obj.getInt("Level")
                    var io:ItemObject = Context.Model.itemsManager.getItem(ItemType.byValue(id))
                    if (io != null)
                        io.addRule(new AccessLevelRule(lev))
                }
                Context.Model.marketManager.setItemPrices(prices)
                //levels
                var levelsArr:ISFSArray = plist.getSFSArray("Levels")
                for (var i:int = 0; i < levelsArr.size(); i++) {
                    var exp:int = levelsArr.getInt(i);
                    Context.Model.experianceManager.levelExperiencePair.push(new ExperianceObject(i + 1, exp))
                }
                //gp
                var gp:GameProfile = GameProfile.fromISFSObject(responseParams);
                profileLoaded.dispatch(gp);
				
				// lottery
				Context.Model.currentSettings.lotteryResourcePrize = new ResourcePrice(
					responseParams.getInt("GoldPrize"),
					responseParams.getInt("CrystalPrize"),
					responseParams.getInt("AdamantiumPrize"),
					responseParams.getInt("AntimatterPrize")
				);
				
				Context.Model.currentSettings.lotteryTryToWinCount = responseParams.getInt("LuckCount");
				
				Context.Model.dispatchCustomEvent(ContextEvent.L_TRY_TO_SHOW_LOTTERY);
				
				// immitation
				Context.Model.currentSettings.gameProfile.gotItems.push(new ItemProfileObject(ItemType.PART_BOOTS, 1));
				Context.Model.currentSettings.gameProfile.packItems.push(new ItemProfileObject(ItemType.PART_BOOTS, 1));
				
				Context.Model.currentSettings.gameProfile.gotItems.push(new ItemProfileObject(ItemType.PART_MAGIC_SNOW, 1));
				Context.Model.currentSettings.gameProfile.packItems.push(new ItemProfileObject(ItemType.PART_MAGIC_SNOW, 1));
				
				
                break;
            case
            INT_BUY_RESOURCES_RESULT:
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
                        // GP event dispatched in EnergyMarketW
                    }
                }
                break;
            case
            INT_BUY_ITEM_RESULT:
                trace("item bought");
                status = responseParams.getBool("interface.buyItem.result.fields.status")
                if (!status) {
                    Context.Model.dispatchCustomEvent(ContextEvent.IT_BUY_FAILED)
                    return
                }
                var iType:ItemType = ItemType.byValue(responseParams.getInt("interface.buyItem.result.fields.itemId"))
                var count:int = responseParams.getInt("interface.buyItem.result.fields.count")
                rp = new ResourcePrice(responseParams.getInt("interface.buyItem.result.fields.resourceType0"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType1"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType2"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType3"))
				
                Context.Model.currentSettings.gameProfile.addItem(iType, count)
                Context.Model.currentSettings.gameProfile.resources.setFrom(rp)
				
                Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.IT_BUY_SUCCESS, {it:iType,count:count})
                Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
                Context.Model.dispatchCustomEvent(ContextEvent.IM_ITEMBUY_SUCCESS, iType)
				
				Context.Model.dispatchCustomEvent(ContextEvent.RGAME_NEED_TO_SET_WEAPON_TO_HAND, iType);
                break;
            case
            INT_GAME_NAME_RESULT:
                newGameNameObtained.dispatch(responseParams.getUtfString("interface.gameManager.findGameName.result.fields.gameName"))
                break;
            case
            INT_FAST_JOIN_RESULT:
                Context.gameModel.fastJoinFailed.dispatch()
                break;
            case
            INT_CREATE_GAME_RESULT:
                Context.gameModel.createGameFailed.dispatch()
                break;
            case
            LOBBY_PROFILES:
                var arr:ISFSArray = responseParams.getSFSArray("profiles");
                var newLPs:Array = getLobbyProfilesFromSFSArray(arr)
                var lp:LobbyProfile = getNewLobbyProfile(newLPs)
                Context.gameModel.lobbyProfiles = newLPs
                Context.gameModel.someoneJoinedToGame.dispatch(lp);
                break;
            case
            LOBBY_READY:
                var ready:Boolean = responseParams.getBool("IsReady")
                var name:String = responseParams.getUtfString("Id");
                var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(name)
                if (lp != null)
                    lp.isReady = ready;
                Context.gameModel.playerReadyChanged.dispatch();
                break;

            //WALL
            case
            "bombersWall.isRegisteredLoaded":
                var flag:Boolean = responseParams.getBool("IsRegistered")
                //mx.controls.Alert.show("Login success -> "+flag.toString());
                
				Context.Model.dispatchCustomEvent(ContextEvent.WALL_FAST_LOGINED, flag ? WallChest.MUST_LOOSE : WallChest.MUST_WIN);
                break;
			
			case 
			INT_TRY_LUCK_RESULT:
			
			
			var newResources: ResourcePrice = new ResourcePrice(
				responseParams.getInt("Gold"),
				responseParams.getInt("Crystal"),
				responseParams.getInt("Adamantium"),
				responseParams.getInt("Antimatter")
			);
			
			//mx.controls.Alert.show(newResources.toString());

			var diff: ResourcePrice = newResources.getDifference(Context.Model.currentSettings.gameProfile.resources);
			var arrRes: Array = diff.getResourceObjectArr();
			var resourceObject:ResourceObject = null;
			
			for each(var ro:ResourceObject in arrRes)
			{
				if(ro.value != 0)
				{
					resourceObject = ro;
					break;
				}
			}
			
			Context.Model.currentSettings.gameProfile.resources = newResources.clone();
			
			Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);
			Context.Model.dispatchCustomEvent(ContextEvent.L_CHEST_IS_CHECKED, resourceObject);
			
			
			break;
			
			case 
			INT_BUY_LUCK_RESULT:
			Context.Model.currentSettings.gameProfile.energy = responseParams.getInt("Energy");
			Context.Model.currentSettings.lotteryTryToWinCount = responseParams.getInt("LuckCount");
			
			Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED);
			Context.Model.dispatchCustomEvent(ContextEvent.L_RESET_CHESTS);
			Context.Model.dispatchCustomEvent(ContextEvent.L_SHOW_CHEST_BLOCK, false);
			
			break;
			
			case 
			INT_TAKE_PRIZE_RESULT:
			
			var newResources: ResourcePrice = new ResourcePrice(
				responseParams.getInt("Gold"),
				responseParams.getInt("Crystal"),
				responseParams.getInt("Adamantium"),
				responseParams.getInt("Antimatter")
			);
			
			Context.Model.currentSettings.gameProfile.resources = newResources.clone();
			Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);
			Context.Model.dispatchCustomEvent(ContextEvent.TL_RESET_PRIZE);
			
			break;
        }
    }

    private function getNewLobbyProfile(newLPs:Array):LobbyProfile {
        if (Context.gameModel.lobbyProfiles == null)
            return null
        for (var i:int = 0; i < newLPs.length; i++) {
            var lpOld:LobbyProfile = Context.gameModel.lobbyProfiles[i];
            var lpNew:LobbyProfile = newLPs[i];
            if (lpOld == null && lpNew != null)
                return lpNew
        }
        return null
    }

    public function getLobbyProfilesFromSFSArray(arr:ISFSArray):Array {
        var resultArray:Array = new Array();
        for (var i:int = 0; i < arr.size(); i++) {
            var item:ISFSObject = arr.getSFSObject(i);
            var id:String = item.getUtfString("Id");
            var exp:int = item.getInt("Experience");
            var nick:String = item.getUtfString("Nick");
            var photo:String = item.getUtfString("Photo");
            var ready:Boolean = item.getBool("IsReady");
            var slot:int = item.getInt("Slot");
            resultArray[slot] = new LobbyProfile(id, nick, photo, exp, slot, ready)
        }
        return resultArray
    }

    private function updLobbyExperience(slot:int, place:int, exp:int):void {
        var lp:LobbyProfile = (Context.gameModel.lastGameLobbyProfiles[slot] as LobbyProfile)
        lp.place = place
        lp.expEarned = exp - lp.experience
        lp.experience = exp
    }
}
}