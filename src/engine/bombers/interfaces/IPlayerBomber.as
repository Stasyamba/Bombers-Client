/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombss.BombType
import engine.utils.Direction
import engine.weapons.WeaponType
import engine.weapons.interfaces.IWeapon

public interface IPlayerBomber extends IBomber {
    function addDirection(dir:Direction):void;

    function removeDirection(dir:Direction):void;

    function setBomb(bombType:BombType):void;

    function tryActivateWeapon():void;

    function activateWeapon(x:int, y:int, type:WeaponType):void;

    function deactivateWeapon(type:WeaponType):void

    function get currentWeapon():IWeapon;

    function decWeapon(wt:WeaponType):void;

    function hit(damage:int):void

    function hitWithoutImmortal(damage:int):void
}
}