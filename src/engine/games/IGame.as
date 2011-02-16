/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager

public interface IGame {

    function get ready():Boolean;

    function get type():GameType;

    function get playerManager():IPlayerManager;

    function get mapManager():IMapManager;

    function get enemiesManager():IEnemiesManager;

    function get explosionsManager():IExplosionsManager;

    //buffer is used to send explosions from syn objects to explosions manager, which operates with blocks of explosions
    function get explosionExchangeBuffer():Array
}
}