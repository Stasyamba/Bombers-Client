package engine.profiles {
import components.common.VkontakteProfile
import components.common.bombers.BomberType
import components.common.items.ItemProfileObject
import components.common.items.ItemType
import components.common.resources.ResourcePrice
import components.common.worlds.WorldsType
import components.common.worlds.locations.LocationType

import engine.bombers.interfaces.IGameSkills
import engine.bombers.mapInfo.GameSkills
import engine.bombers.skin.BomberSkin
import engine.profiles.interfaces.IGameProfile

public class GameProfile implements IGameProfile {

    private var _name:String = "";
    public var expirance:int;

    public var id:String = "";

    public var currentLocation:LocationType;
    public var currentWorld:WorldsType = WorldsType.WORLD1;


    private var _selectedWeaponLeftHand:ItemProfileObject;
    private var _selectedWeaponRightHand:ItemProfileObject;

    /**
     * BomberType
     */
    public var currentBomberType:BomberType;
    public var resources:ResourcePrice = new ResourcePrice(20, 20, 0, 0);

    /**
     * content = [LocationType, ...]
     */
    public var openedLocations:Array = [LocationType.WORLD1_GRASSFIELDS, LocationType.WORLD1_CASTLE];

    /**
     * content = [ItemProfileObject, ...]
     */
    public var packItems:Array = new Array();
    /**
     * content = [ItemProfileObject, ...]
     */
    public var gotItems:Array = new Array();
    /**
     * content = [ItemProfileObject, ...]
     */
    private var _aursTurnedOn:Array = new Array();


    public var vkProfile:VkontakteProfile;


    public function GameProfile() {
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    /**
     * content = [ItemType, ...]
     */
    public function get aursTurnedOn():Array {
        return _aursTurnedOn;
    }

    public function initGameProfile():void {
        packItems = new Array();
        gotItems.push(new ItemProfileObject(ItemType.QUEST_ITEM_CANARY, -1));
        gotItems.push(new ItemProfileObject(ItemType.NUCLEAR_BOMB, 2));
        gotItems.push(new ItemProfileObject(ItemType.QUEST_ITEM_SNOWBOOTS, -1));
        gotItems.push(new ItemProfileObject(ItemType.AURA_FIRE, -1));
        gotItems.push(new ItemProfileObject(ItemType.X_RAY_BOMB, 10));
        gotItems.push(new ItemProfileObject(ItemType.MINA_BOMB, 5));
        gotItems.push(new ItemProfileObject(ItemType.HAMELEON_POISON, 0));

        for each(var ipo:ItemProfileObject in gotItems) {
            packItems.push(ipo);
        }

        _aursTurnedOn = [null, null, null]
        setAura(null, ItemType.AURA_FIRE);


        selectedWeaponRightHand = new ItemProfileObject(ItemType.BASE_BOMB, -1);
        selectedWeaponLeftHand = packItems[1];

        currentBomberType = BomberType.FURY_JOE;
    }

    /* GET and SET */

    /**
     * ItemProfileObject
     */
    public function get selectedWeaponRightHand():ItemProfileObject {
        return _selectedWeaponRightHand;
    }

    /**
     * @private
     */
    public function set selectedWeaponRightHand(value:ItemProfileObject):void {
        _selectedWeaponRightHand = value;
    }

    /**
     * ItemProfileObject
     */
    public function get selectedWeaponLeftHand():ItemProfileObject {
        return _selectedWeaponLeftHand;
    }

    /**
     * @private
     */
    public function set selectedWeaponLeftHand(value:ItemProfileObject):void {
        var finded:Boolean = false;
        var tmpArr:Array = new Array();

        if (value != null) {
            for each(var ipo:ItemProfileObject in packItems) {
                if (ipo.itemType != value.itemType) {
                    tmpArr.push(ipo);
                } else {
                    finded = true;
                }
            }

            if (finded) {
                packItems = new Array();

                for each(ipo in tmpArr) {
                    packItems.push(ipo);
                }

                if (_selectedWeaponLeftHand != null) {
                    packItems.push(_selectedWeaponLeftHand.clone());
                }

                _selectedWeaponLeftHand = value;

            }

        } else {
            packItems.push(_selectedWeaponLeftHand);
            _selectedWeaponLeftHand = null;
        }


        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED);
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
    }


    public function setAura(itemType:ItemType, newItemType:ItemType):void {

        for (var i:int = 0; i <= _aursTurnedOn.length - 1; i++) {
            if (_aursTurnedOn[i] == itemType) {
                _aursTurnedOn[i] = newItemType;
                break;
            }
        }

        // delete from gotItems
        if (itemType == null) {
            var tmpArr:Array = new Array();
            var finded:Boolean = false;

            for each(var ipo:ItemProfileObject in packItems) {
                if (ipo.itemType != newItemType) {
                    tmpArr.push(ipo);
                } else {
                    finded = true;
                }
            }

            if (finded) {
                packItems = new Array();
                for each(ipo in tmpArr) {
                    packItems.push(ipo);
                }
            }

        }

        // put into gotItems
        if (newItemType == null) {
            packItems.push(new ItemProfileObject(itemType, -1));
        }

        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
        Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED);
    }


    public function getGameSkills():IGameSkills {
        return new GameSkills();
    }

    public function getSkin(playerId:int):BomberSkin {
        if (playerId % 2 != 0)
            return Context.imageService.getBomberSkin("fury")
        return Context.imageService.getBomberSkin("robot")
    }


}
}