/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IBomber

public interface IActiveMapBlockState extends IMapBlockState {
    function activateOn(bomber:CreatureBase):void
}
}
