/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.explosionss.interfaces.IExplosion

public interface IExplosionsManager {

    function checkExplosions(elapsedMiliSecs:int):void;

    function addExplosions(expls:Array):void;

    function updateAllExplosions():void;

    function get allExplosions():IExplosion;
}
}