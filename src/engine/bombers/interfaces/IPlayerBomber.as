/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombss.BombType
import engine.utils.Direction
import engine.weapons.interfaces.IWeapon

public interface IPlayerBomber extends IBomber {
    function addDirection(dir:Direction):void;

    function removeDirection(dir:Direction):void;

    function setBomb(bombType:BombType):void;

    function tryUseWeapon():void;

    function activateWeapon():void;

    function deactivateWeapon():void

    function get currentWeapon():IWeapon;
}
}