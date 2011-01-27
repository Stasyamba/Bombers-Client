/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombss.BombType
import engine.utils.Direction

public interface IPlayerBomber extends IBomber {
    function addDirection(dir:Direction):void;

    function removeDirection(dir:Direction):void;

    function setBomb(bombType:BombType):void;

    function tryUseWeapon():void;
}
}