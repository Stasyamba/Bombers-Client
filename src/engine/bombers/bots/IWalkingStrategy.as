/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.bots {
import engine.bombers.interfaces.IMapCoords
import engine.utils.Direction

public interface IWalkingStrategy {

    function getDirection(dir:Direction, _coords:IMapCoords):Direction;
}
}