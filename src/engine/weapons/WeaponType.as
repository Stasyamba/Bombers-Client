/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
public class WeaponType {

    public static const NULL:WeaponType = new WeaponType(-1, "NULL");
    //bombs
    public static const REGULAR_BOMB_WEAPON:WeaponType = new WeaponType(00, "REGULAR_BOMB_WEAPON");
    public static const ATOM_BOMB_WEAPON:WeaponType = new WeaponType(01, "ATOM_BOMB_WEAPON");
    public static const BOX_BOMB_WEAPON:WeaponType = new WeaponType(02, "BOX_BOMB_WEAPON")
    public static const DYNAMITE_WEAPON:WeaponType = new WeaponType(03, "DYNAMITE_WEAPON");
    public static const SMOKE_BOMB_WEAPON:WeaponType = new WeaponType(04, "SMOKE_BOMB_WEAPON")
    //potions
    public static const HAMELEON:WeaponType = new WeaponType(21, "HAMELEON_WEAPON",true);
    public static const LITTLE_HEALTH_PACK_WEAPON:WeaponType = new WeaponType(22, "LITTLE_HEALTH_PACK_WEAPON",true)
    public static const MEDIUM_HEALTH_PACK_WEAPON:WeaponType = new WeaponType(23, "MEDIUM_HEALTH_PACK_WEAPON",true)
    //mines
    public static const REGULAR_MINE:WeaponType = new WeaponType(41, "REGULAR_MINE_WEAPON");
    //auras
    public static const ICE_AURA:WeaponType = new WeaponType(71, "ICE_AURA");
    public static const FIRE_AURA:WeaponType = new WeaponType(72, "FIRE_AURA");
    public static const SPEED_AURA:WeaponType = new WeaponType(73, "SPEED_AURA");
    public static const BOMB_COUNT_AURA:WeaponType = new WeaponType(74, "BOMB_COUNT_AURA");
    public static const BOMB_POWER_AURA:WeaponType = new WeaponType(75, "BOMB_POWER_AURA");
    public static const START_LIFE_AURA:WeaponType = new WeaponType(76, "START_LIFE_AURA");


    private var _value:int;
    private var _key:String;
    private var _decreaseOnActivate:Boolean


    public function WeaponType(value:int, key:String,decreaseOnActivate:Boolean = false) {
        _value = value;
        _key = key;
        _decreaseOnActivate = decreaseOnActivate
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function get decreaseOnActivate():Boolean {
        return _decreaseOnActivate
    }

    public static function byValue(value:int):WeaponType {
        switch (value) {
            case REGULAR_BOMB_WEAPON.value:
                return REGULAR_BOMB_WEAPON
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
            case DYNAMITE_WEAPON.value:
                return DYNAMITE_WEAPON
            case SMOKE_BOMB_WEAPON.value:
                return SMOKE_BOMB_WEAPON
            case LITTLE_HEALTH_PACK_WEAPON.value:
                return LITTLE_HEALTH_PACK_WEAPON
            case MEDIUM_HEALTH_PACK_WEAPON.value:
                return MEDIUM_HEALTH_PACK_WEAPON
        }
        return NULL
    }
}
}