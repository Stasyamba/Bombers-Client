/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import components.common.worlds.locations.LocationType

import engine.model.managers.interfaces.IExplosionsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.quest.MonstersManager

public interface IGame {

    function get ready():Boolean;

    function get type():GameType;

    function get playerManager():IPlayerManager;

    function get mapManager():IMapManager;

    function get explosionsManager():IExplosionsManager;

    //buffer is used to send explosions from syn objects to explosions manager, which operates with blocks of explosions
    function get explosionExchangeBuffer():Array

    function get location():LocationType

    function get monstersManager():MonstersManager
}
}