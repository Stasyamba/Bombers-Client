/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.explosionss.interfaces.IExplosion

import mx.collections.ArrayList

public interface IExplosionsManager {

    function checkExplosions(elapsedMiliSecs:Number):void;

    function addExplosions(expls:ArrayList):void;

    function updateAllExplosions():void;

    function get allExplosions():IExplosion;
}
}