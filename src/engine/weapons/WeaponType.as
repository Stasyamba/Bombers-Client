/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
public class WeaponType {

    public static const ATOM_BOMB_WEAPON:WeaponType = new WeaponType(01, "ATOM_BOMB_WEAPON");
    public static const NULL:WeaponType = new WeaponType(-1, "NULL");
    public static const HAMELEON:WeaponType = new WeaponType(21, "HAMELEON_WEAPON");
    public static const BOX_BOMB_WEAPON:WeaponType = new WeaponType(02, "BOX_BOMB_WEAPON")
    public static const REGULAR_MINE:WeaponType = new WeaponType(41, "REGULAR_MINE_WEAPON");
    public static const SPEED_AURA:WeaponType = new WeaponType(71, "SPEED_AURA");
    public static const FIRE_AURA:WeaponType = new WeaponType(72, "FIRE_AURA");

    private var _value:int;
    private var _key:String;
    public static const DYNAMITE_WEAPON:WeaponType = new WeaponType(03, "DYNAMITE_WEAPON");

    public function WeaponType(value:int, key:String) {
        _value = value;
        _key = key;
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public static function byValue(value:int):WeaponType {
        switch(value){
            case ATOM_BOMB_WEAPON.value:
                return ATOM_BOMB_WEAPON
            case HAMELEON.value:
                return HAMELEON
            case BOX_BOMB_WEAPON.value:
                return BOX_BOMB_WEAPON
            case REGULAR_MINE.value:
                return REGULAR_MINE
            case SPEED_AURA.value:
                return SPEED_AURA
            case FIRE_AURA.value:
                return FIRE_AURA

        }
        return NULL
    }
}
}