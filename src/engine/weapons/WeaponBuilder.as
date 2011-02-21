/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import components.common.items.ItemType

import engine.model.managers.regular.MapManager
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IMineWeapon
import engine.weapons.interfaces.IWeapon

public class WeaponBuilder {
    private var _mapManager:MapManager

    public function WeaponBuilder(mapManager:MapManager) {
        _mapManager = mapManager
    }

    public function makeSpecialBomb(charges:int, type:WeaponType):IActivatableWeapon {
        switch (type) {
            case WeaponType.ATOM_BOMB_WEAPON:
                return new AtomBombWeapon(_mapManager, charges);
            case WeaponType.BOX_BOMB_WEAPON:
                return new BoxBombWeapon(_mapManager, charges);
            case WeaponType.DYNAMITE_WEAPON:
                return new DynamiteWeapon(_mapManager, charges);
            case WeaponType.SMOKE_BOMB_WEAPON:
                return new SmokeBombWeapon(_mapManager,charges)
        }
        throw new ArgumentError("unknown special bomb type");
    }

    public function makePotion(duration:int, charges:int, type:WeaponType):IActivatableWeapon {
        switch (type) {
            case WeaponType.HAMELEON:
                return new HameleonWeapon(duration, charges)
            case WeaponType.LITTLE_HEALTH_PACK_WEAPON:
                return new LittleHealthPack(charges)
            case WeaponType.MEDIUM_HEALTH_PACK_WEAPON:
                return new MediumHealthPack(charges)
        }
        throw new ArgumentError("unknown potion type")
    }

    public function makeMine(charges:int, type:WeaponType):IMineWeapon {
        switch (type) {
            case WeaponType.REGULAR_MINE:
                return new RegularMineWeapon(charges, _mapManager)
        }
        throw new ArgumentError("unknown mine type")
    }

    public function fromItemType(itemType:ItemType, itemCount:int):IWeapon {
        var weapType:WeaponType = WeaponType.byValue(itemType.value)
        return fromWeaponType(weapType, itemCount)
    }

    public function fromWeaponType(weaponType:WeaponType, count:int):IWeapon {
        switch (weaponType) {
            case WeaponType.ATOM_BOMB_WEAPON:
            case WeaponType.BOX_BOMB_WEAPON:
            case WeaponType.DYNAMITE_WEAPON:
            case WeaponType.SMOKE_BOMB_WEAPON:
                return makeSpecialBomb(count, weaponType);
            case WeaponType.HAMELEON:
                return makePotion(HameleonWeapon.DURATION, count, weaponType)
            case WeaponType.LITTLE_HEALTH_PACK_WEAPON:
            case WeaponType.MEDIUM_HEALTH_PACK_WEAPON:
                return makePotion(0, count, weaponType)
            case WeaponType.REGULAR_MINE:
                return makeMine(count, weaponType)
        }
        throw new ArgumentError("unknown weapon type " + weaponType.key)
    }
}
}
