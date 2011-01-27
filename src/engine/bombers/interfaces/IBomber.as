/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.model.signals.StateAddedSignal
import engine.model.signals.StateRemovedSignal
import engine.playerColors.PlayerColor
import engine.weapons.interfaces.IWeapon

import org.osflash.signals.Signal

public interface IBomber {
    function get gameSkin():IGameSkin;

    function get playerId():int;

    function get userName():String;

    function get life():int;

    function putOnMap(map:IMap, x:int, y:int):void;

    function get coords():IMapCoords;

    function move(elapsedSeconds:Number):void;

    function get gameSkills():IGameSkills;

    /**
     *
     * @param expl
     * @return is player dead after explosion
     */
    function explode(expl:IExplosion):void;

    function get becameUntouchable():Signal;

    function get lostUntouchable():Signal;

    function get isImmortal():Boolean;

    function get color():PlayerColor;

    function set life(life:int):void;

    function get isDead():Boolean;

    function kill():void;

    function get stateAdded():StateAddedSignal

    function get stateRemoved():StateRemovedSignal;

    function activateWeapon():void;

    function deactivateWeapon():void

    function get weapon():IWeapon;
}
}