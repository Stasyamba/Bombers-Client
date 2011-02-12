package engine.profiles {
import com.smartfoxserver.v2.entities.data.ISFSArray
import com.smartfoxserver.v2.entities.data.ISFSObject

import components.common.bombers.BomberType
import components.common.items.ItemProfileObject
import components.common.items.ItemType
import components.common.resources.ResourcePrice
import components.common.worlds.WorldsType
import components.common.worlds.locations.LocationType

import engine.bombers.skin.BomberSkin

public class GameProfile {

    private var _nick:String;
    public var expirance:int;
    public var energy:int;
    public var id:int;
    public var photoURL:String = "http://moikompas.ru/img/compas/2008-01-04/gennifer_lopes/31534971.jpg";

    public var currentLocation:LocationType;
    public var currentWorld:WorldsType;


    private var _selectedWeaponLeftHand:ItemProfileObject;
    private var _selectedWeaponRightHand:ItemProfileObject;

    /**
     * BomberType
     */
    public var currentBomberType:BomberType;
    public var resources:ResourcePrice;

    /**
     * content = [LocationType, ...]
     */
    public var openedLocations:Array = [LocationType.WORLD1_GRASSFIELDS];
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
    private var _aursTurnedOn:Array = [null,null,null];

    /*
     * content = [BomberType,...]
     * */
    public var bombersOpened = [BomberType.FURY_JOE,BomberType.R2D3];
    //public var vkProfile:VkontakteProfile;


    public function GameProfile() {
    }

    public function get nick():String {
        return _nick;
    }

    public function set nick(value:String):void {
        _nick = value;
    }

    /**
     * content = [ItemType, ...]
     */
    public function get aursTurnedOn():Array {
        return _aursTurnedOn;
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


    public function setAura(itemType:ItemType, newItemType:ItemType, dispatchEvents:Boolean = true):void {

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
        if (dispatchEvents) {
            Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
            Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED);
        }
    }

    public function getSkin(playerId:int):BomberSkin {
        if (playerId % 2 != 0)
            return Context.imageService.getBomberSkin("fury")
        return Context.imageService.getBomberSkin("robot")
    }

    public static function fromISFSObject(obj:ISFSObject):GameProfile {
        var res:GameProfile = new GameProfile();
        res.id = obj.getInt("Id");
        res.nick = obj.getUtfString("Nick");
        res.expirance = obj.getInt("Experience")
        res.energy = obj.getInt("Energy")
        res.currentBomberType = BomberType.byValue(obj.getInt("CurrentBomber"))
        res.selectedWeaponRightHand = new ItemProfileObject(res.currentBomberType.baseBomb, -1);

        var items:ISFSArray = obj.getSFSArray("WeaponsOpen");
        for (var i:int = 0; i < items.size(); i++) {
            var objItem:ISFSObject = items.getSFSObject(i);
            var itemId:int = objItem.getInt("WeaponId");
            var itemCount:int = objItem.getInt("Count");
            var modelItem:ItemProfileObject = new ItemProfileObject(ItemType.byValue(itemId), itemCount);
            res.packItems.push(modelItem);
            res.gotItems.push(modelItem);
        }
        var a:int = obj.getInt("AuraOne");
        if (a != 0)
            res.setAura(null, ItemType.byValue(a),false)
        a = obj.getInt("AuraTwo");
        if (a != 0)
            res.setAura(null, ItemType.byValue(a),false)
        a = obj.getInt("AuraThree");
        if (a != 0)
            res.setAura(null, ItemType.byValue(a),false)

        res.resources = new ResourcePrice(obj.getInt("Gold"), obj.getInt("Crystal"), obj.getInt("Adamantium"), obj.getInt("Antimatter"))

        items = obj.getSFSArray("LocationsOpen");
        for (i = 0; i < items.size(); i++) {
            res.openedLocations.push(LocationType.byValue(items.getInt(i)))
        }

        items = obj.getSFSArray("BombersOpen");
        for (i = 0; i < items.size(); i++) {
            res.bombersOpened.push(BomberType.byValue(items.getInt(i)))
        }
        return res;
    }

    public function addItem(iType:ItemType, count:int):void {
        if(selectedWeaponRightHand.itemType == iType){
            selectedWeaponRightHand.itemCount += count
            return
        }else{
            for (var i:int = 0; i < gotItems.length; i++) {
                var io:ItemProfileObject = gotItems[i];
                if(io.itemType == iType) {
                    io.itemCount += count
                    return
                }
            }
        }
        io = new ItemProfileObject(iType,count)
        gotItems.push(io)
        packItems.push(io)
    }
}
}


