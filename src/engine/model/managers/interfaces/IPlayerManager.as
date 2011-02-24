/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject

public interface IPlayerManager {
    function get me():IPlayerBomber;

    function get mySlot():int;

    function setPlayer(player:IPlayerBomber):void;

    function movePlayer(elapsedMiliSecs:int):void;

    function checkPlayerMetExplosion(expl:IExplosion):void;

    function checkPlayerMetObject(bonus:IDynObject):Boolean;

    function checkPlayerMetDieWall(x:int, y:int):Boolean;

    function killMe():void;

    function isItMe(bomber:IBomber):Boolean
}
}