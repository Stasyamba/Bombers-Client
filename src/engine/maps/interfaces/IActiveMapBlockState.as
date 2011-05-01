/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.CreatureBase

public interface IActiveMapBlockState extends IMapBlockState {

    function activateOn(creature:CreatureBase):void

    function deactivateOn(creature:CreatureBase):void
}
}
