/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombss.BombsBuilder
import engine.maps.builders.MapObjectBuilder
import engine.model.managers.interfaces.IObjectManager
import engine.model.managers.regular.MapManager
import engine.model.managers.regular.MapObjectManager
import engine.weapons.BoxBombWeapon
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IMineWeapon
import engine.weapons.interfaces.IWeapon

public class WeaponBuilder {
    private var _bombsBuilder:BombsBuilder
    private var _mapManager : MapManager
    private var _objectBuilder:MapObjectBuilder
    private var _objectManager:IObjectManager

    public function WeaponBuilder(bombsBuilder:BombsBuilder, mapManager:MapManager, objectBuilder:MapObjectBuilder, objectManager:IObjectManager) {
        _bombsBuilder = bombsBuilder
        _mapManager = mapManager
        _objectBuilder = objectBuilder
        _objectManager = objectManager
    }

    public function makeSpecialBomb(charges:int,type:WeaponType):IActivatableWeapon {
        switch (type){
            case WeaponType.ATOM_BOMB_WEAPON:
                return new AtomBombWeapon(_mapManager,_bombsBuilder,charges);
            case WeaponType.BOX_BOMB_WEAPON:
                return new BoxBombWeapon(_mapManager,_bombsBuilder,charges);
            case WeaponType.DYNAMITE_WEAPON:
                return new DynamiteWeapon(_mapManager,_bombsBuilder,charges);
        }
        throw new ArgumentError("unknown special bomb type");
    }

    public function makePotion(duration:Number,charges:int,type:WeaponType ):IDeactivatableWeapon {
        switch(type){
            case WeaponType.HAMELEON:
                return new HameleonWeapon(duration,charges)
        }
        throw new ArgumentError("unknown potion type")
    }

     public function makeMine(charges:int,type:WeaponType ):IMineWeapon {
        switch(type){
            case WeaponType.REGULAR_MINE:
                return new RegularMineWeapon(charges,_mapManager,_objectBuilder,_objectManager)
        }
        throw new ArgumentError("unknown mine type")
    }
}
}
