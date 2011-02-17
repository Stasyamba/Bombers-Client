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

import org.osflash.signals.Signal

public interface IBomber {
    function get gameSkin():IGameSkin;

    function get playerId():int;

    function get userName():String;

    function putOnMap(map:IMap, x:int, y:int):void;

    function get coords():IMapCoords;

    function move(elapsedMilliSeconds:int):void;

    /**
     *
     * @param expl
     * @return is player dead after explosion
     */
    function explode(expl:IExplosion):void;

    function get becameImmortal():Signal;

    function get lostImmortal():Signal;

    function get isImmortal():Boolean;

    function get color():PlayerColor;

    function get isDead():Boolean;

    function kill():void;

    function get stateAdded():StateAddedSignal

    function get stateRemoved():StateRemovedSignal;

    //skills

    function get life():int;

    function set life(life:int):void;

    function get startLife():int

    function get speed():Number

    function get baseSpeed():Number

    function get bombCount():int

    function get baseBombCount():int

    function get bombPower():int

    function get baseBombPower():int

    function get immortalTime():int

    function incSpeed():void

    function incBombCount():void

    function incBombPower():void

    function takeBomb():void;

    function returnBomb():void;
}
}