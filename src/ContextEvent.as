package {
import flash.events.Event;

public class ContextEvent extends Event {
    public static const USERS_PROFILES_LOADED:String = "UsersProfileLoaded";

    public static const MAIN_TAB_CHANGED:String = "MainTabChanged";
    public static const NEED_TO_CHANGE_MAIN_TAB:String = "NeedToChangeMainTab";
    // pass: String (const) -> tab name (const in ApplicationView)

    public static const SHOW_MAIN_PREALODER:String = "ShowMainPreloder";
    // pass: Boolean -> preloader visible
    public static const NEED_TO_SHOW_ERROR:String = "NeedToShowError";
    public static const NEED_TO_SHOW_DISCONNECTED_WINDOW:String = "NeedToShowDisconnectedWindow"
    public static const NEED_TO_SHOW_CANT_CONNECT_WINDOW:String = "NeedToShowCantConnectWindow"
	public static const NEED_TO_OPEN_TAKE_LOOT_WINDOW: String = "NeedToOpenTakeLootWindow";	
	public static const NEED_TO_OPEN_GAME_CREATING_WINDOW: String = "NeedToOpenGameCreatingWindow";
	
	
	
    /***** worlds and locations *****/
    public static const NEED_TO_CHANGE_WORLD:String = "NeedToChangeWorld";
    public static const NEED_TO_CHANGE_LOCATION:String = "NeedToChangeLocation";

    public static const NEED_TO_OPEN_LOCATION_ENTER:String = "NeedToOpenLocationEnter";
    // pass: LocationType


    /***** friends creating game popUp *****/
    public static const NEED_TO_SHOW_WARNING_FRIENDS_GAMEW:String = "NeedToShowWarningFriendsGame";
    public static const NEED_TO_SHOW_ERROR_FRIENDS_GAMEW:String = "NeedToShowErrorFriendsGame"


    /***** world page - bottom panel events *****/
    public static const CHANGE_BOTTOM_PANEL_BUTTONS_ACTIVITY:String = "ChangeBottomPanelButtonsActivity";
    // pass data: enabled: Boolean -> enabled of buttons of bottom menu


    /***** resource market events *****/
    public static const NEED_TO_OPEN_RESOURCE_MARKET:String = "NeedToOpenMarket";
    // pass: ResourcePrice -> set by default in market
	public static const NEED_TO_CLOSE_RESOURCE_MARKET:String = "NeedToCloseMarket";
	
    public static const RESOURCE_VALUE_CHANGED:String = "ResourceValueChanged";
    // pass: {resourceType: ResourceType, value: int} -> resource that was changed


    /***** game profile profile property change events *****/
    public static const GP_RESOURCE_CHANGED:String = "GPResourceChanged";
    public static const GP_CURRENT_LEFT_WEAPON_IS_CHANGED:String = "GPCurrentLeftWeaponIsChanged";
    public static const GP_GOTITEMS_IS_CHANGED:String = "GPGotItemsIsChanged";
    public static const GP_PACKITEMS_IS_CHANGED:String = "GPPackItemsIsChanged";
    public static const GP_AURS_TURNED_ON_IS_CHANGED:String = "GPAursTurnedOnIsChanged";
    public static const GP_ENERGY_IS_CHANGED:String = "GPEnegryIsChanged";
    public static const GP_EXPERIENCE_CHANGED:String = "GPExperienceChanged";
	// pass: int -> new expirance
    public static const GP_CURRENT_BOMBER_CHANGED:String = "GPCurrentBomberChanged";


    /***** inventory market events *****/

    public static const NEED_TO_OPEN_INVENTORY_MARKET:String = "IMNeedToOpenInventoryMarket";
    // pass: Boolean -> isUserInTheGame (for game special market window with blocked elements)

    public static const IM_CATEGORY_TAB_STATE_CHANGED:String = "IMInventoryTabStateChanged";
    // pass: int (const) -> new state (const in WeaponCategoriesTopMenu)

    public static const IM_CATEGORY_TAB_CHANGED:String = "IMCategoryIsChanged";
    // pass: MarketCategory -> tab

    public static const IM_NEED_TO_CHANGE_BOMBER_BUTTON_EQUIP_STATE:String = "IMNeedToChangeBomberEquipSate";
    // pass: int (const) -> new state (const in BomberEquipButton.mxml)

    public static const IM_NEED_TO_SHOW_BOMBER_CONTENT:String = "IMNeedToShowBomberContent";
    public static const IM_NEED_TO_SHOW_MARKET_CONTENT:String = "IMNeedToShowMarketContent";
    // pass: MarketCategory

    public static const IM_SERVERREQUEST:String = "IMServerRequest";
    // pass: Boolean -> true = start request, false = end request

    public static const IM_RIGHT_CONTENT_WARNING:String = "IMRightContentWarning";
    // pass: String -> Warning message

    public static const IM_RIGHT_CONTENT_CONFIRM:String = "IMRightContentConfirm";
    // pass: {message: String, itemType:ItemType, actionType: int (const)} -> Confirm message const in InventoryMarket.mxml

    public static const IM_RIGHT_CONTENT_INFO:String = "IMRightContentInfo";
    // pass: ItemType
	public static const IM_RIGHT_SHOW_COLLECTION:String = "IMRightShowCollection";
	// pass: ItemColelctionType

    public static const IM_REMOVE_RIGHT_CONTENT_SUB_MENU:String = "IMRemoveRightContentSubMenu";
    public static const IM_REMOVE_ITEM_RULES_DENIED_CONTENT:String = "IMRemoveNotEnoughtMoneyContent";
    public static const IM_ITEMBUY_SUCCESS:String = "IMWeaponBoughtSuccess";

    /***** enegry market events *****/
    public static const NEED_TO_OPEN_ENERGY_MARKET:String = "IMNeedToOpenEnergyMarket";

    /***** game page event *****/
    public static const GPAGE_NEED_TO_SHOW_GAME_IS_CREATED_WINDOW:String = "GPAGENeedToShowGameIsCreatedWindow";
    public static const GPAGE_NEED_TO_SHOW_GAME_READY_WINDOW:String = "GPAGENeedToShowGameReadyWindow";
    public static const GPAGE_NEED_TO_SHOW_IS_PLAYING_PACK_WINDOW:String = "GPAGENeedToShowIsPlayingPackWindow";
    public static const GPAGE_NEED_TO_SHOW_QUIT_THE_GAME_WINDOW:String = "GPAGENeedToShowQuitTheGameWindow";
    public static const GPAGE_NEED_TO_SHOW_RESULTS_WINDOW:String = "GPAGENeedToShowResultsWindow";
    // pass: GameResults
    public static const GPAGE_NEED_TO_SHOW_THREESEC_WINDOW:String = "GPAGENeedToShowThreeSecWindow";
    public static const GPAGE_NEED_TO_CLOSE_GAME_IS_CREATED_WINDOW:String = "GPAGENeedToCloseGameIsCreatedWindow"
    public static const GPAGE_NEED_TO_CLOSE_GAME_READY_WINDOW:String = "GPAGENeedToCloseGameReadyWindow"

    public static const GPAGE_MY_PARAMETERS_IS_CHANGED:String = "GPAGEMyParametersIsChanged";
    public static const GPAGE_UPDATE_GAME_WEAPONS:String = "GPAGEUpdateGameWeapons";
	public static const GPAGE_NEED_TO_SET_GAME_FOCUS:String = "GPAGENeedToSetGameFocus";
	
	/** result game window events **/
	public static const RGAME_NEED_TO_SET_WEAPON_TO_HAND:String = "RGAMENeedToSetWeaponToHand";
	// pass: ItemType
	
	
	/***** buy events: resources(RS), energy(EN), items(IT) *****/
	
	
	
    public static const RS_BUY_FAILED:String = "RSBuyFailed"
    public static const RS_BUY_SUCCESS:String = "RSBuySuccess"
    //pass: ResourcePrice -> how much bought each resource
    //EN_BUY_FAILED == RS_BUY_FAILED

    public static const EN_BUY_SUCCESS:String = "ENBuySuccess"
    //pass: int -> how much bought energy

    public static const IT_BUY_FAILED:String = "ITBuyFailed"
    public static const IT_BUY_SUCCESS:String = "ITBuySuccess"
    //pass: {it:ItemType, count:int} -> how much bought weapon


    /***** other events *****/
    public static const OE_SHOW_REQUEST_TO_GAME_WINDOW:String = "OENeedToOpenRequestToGameWindow";
    public static const OE_REQUEST_COLLECTION_IS_CHANGED:String = "OERequestCollectionIsChanged";
    // pass: {isActionDelete: Boolean, index: int} -> index element that was deleted
    public static const OE_NEW_REQUEST_TO_GAME:String = "OENewRequestToGame";
    // pass: RequestGameObject
    public static const OE_CHANGE_REQEUST_TO_GAME_BUTTON_ACTIVITY:String = "QEChangeRequestToGameButtonActivity";
    // pass: Boolean


    /***** common events *****/
    public static const BOMBER_CHANGED:String = "BomberChanged";
    public static const GAME_PROFILE_LOADED:String = "GameProfileLoaded";

	
	/** lottery events **/
	public static const L_SHOW_CHEST_BLOCK:String = "LShowChestBlock";
	public static const L_NEED_TO_SHOW_LOTTERY:String = "LNeedToShowLottery";
	public static const L_TRY_TO_SHOW_LOTTERY:String = "LTryToShowLottery";
	// pass: Boolean -> show or hide chest block
	public static const L_RESET_CHESTS:String = "LResetChests";
	public static const L_TRY_COUNT_SET_CHANGED:String = "LTryCountSetChanged";
	public static const L_CHEST_IS_CHECKED:String = "LChestIsChecked";
	// pass: ResourceObject -> if empty = null
	
	/** take loot events **/
	public static const TL_RESET_PRIZE:String = "TLResetPrize";
	
	/** vk events **/
	public static const VK_SEND_TO_WALL:String = "VKSendToWall";
	// pass: SendWallObject
 	
	/** wall events **/
	public static const WALL_TRY_COUNT_CHANGED: String = "WALLTryCountChanged";
	public static const WALL_FAST_LOGINED: String = "WALLFastLogined";
	// pass: boolean -> lottery type (const in WallChest.mxml)
	
    public var data:*;


    public function ContextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

    public override function toString():String {
        return formatToString("ContextEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
    }

    public override function clone():Event {
        return new ContextEvent(type, bubbles, cancelable, data);
    }

}
}