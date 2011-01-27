/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombers.interfaces.IPlayerBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapObject

public interface IPlayerManager {
    function get me():IPlayerBomber;

    function get myId():int;

    function setPlayer(player:IPlayerBomber):void;

    function movePlayer(elapsedMiliSecs:int):void;

    function checkPlayerMetExplosion(expl:IExplosion):void;

    function checkPlayerMetObject(bonus:IMapObject):Boolean;

    function checkPlayerMetDieWall(x:int, y:int):Boolean;

    function killMe():void;
}
}