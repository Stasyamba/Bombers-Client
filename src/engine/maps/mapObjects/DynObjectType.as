/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects {
import engine.bombss.BombType
import engine.maps.interfaces.IDynObjectType
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.maps.mapObjects.special.SpecialObjectType
import engine.utils.Utils

import loading.LoaderUtils

public class DynObjectType implements IDynObjectType {

    public static const NULL:DynObjectType = new DynObjectType(-1, "NULL");

    private var _value:int;
    private var _key:String;

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function DynObjectType(value:int, key:String) {
        _value = value;
        _key = key;
    }

    public static function byValue(value:int):IDynObjectType {
        if (Utils.between(1011, value, 1013))
            return SpecialObjectType.byValue(value)

        switch (value) {
            case NULL.value:return NULL;
            case BonusType.ADD_BOMB.value:return BonusType.ADD_BOMB;
            case BonusType.ADD_BOMB_POWER.value:return BonusType.ADD_BOMB_POWER;
            case BonusType.ADD_SPEED.value:return BonusType.ADD_SPEED;
            case BonusType.HEAL.value:return BonusType.HEAL;
            case BonusType.EXPERIENCE.value:return BonusType.EXPERIENCE;
            case BonusType.RESOURCE.value:return BonusType.RESOURCE;

            case BombType.REGULAR.value:return BombType.REGULAR
            case BombType.BOX.value:return BombType.BOX
            case BombType.ATOM.value:return BombType.ATOM
            case BombType.DYNAMITE.value:return BombType.DYNAMITE
            case BombType.SMOKE.value:return BombType.SMOKE

            case MineType.REGULAR.value: return MineType.REGULAR
        }
        throw new ArgumentError("bad value")
    }

    public static function byKey(key:String):IDynObjectType {
        switch (key) {
            case NULL.key:return NULL;
            case BonusType.ADD_BOMB.key:return BonusType.ADD_BOMB;
            case BonusType.ADD_BOMB_POWER.key:return BonusType.ADD_BOMB_POWER;
            case BonusType.ADD_SPEED.key:return BonusType.ADD_SPEED;
            case BonusType.HEAL.key:return BonusType.HEAL;
            case BonusType.EXPERIENCE.key:return BonusType.EXPERIENCE;
            case BonusType.RESOURCE.key:return BonusType.RESOURCE;

            case BombType.REGULAR.key:return BombType.REGULAR
            case BombType.BOX.key:return BombType.BOX
            case BombType.ATOM.key:return BombType.ATOM
            case BombType.DYNAMITE.key:return BombType.DYNAMITE
        }
        throw new ArgumentError("bad value " + key)
    }

    public function get waitToAdd():int {
        return 0
    }

    public function get stringId():String {
        return LoaderUtils.stringId(value)
    }
}
}