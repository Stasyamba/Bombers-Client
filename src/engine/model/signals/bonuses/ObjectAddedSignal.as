/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IDynObjectType

import org.osflash.signals.Signal

public class ObjectAddedSignal extends Signal {
    public function ObjectAddedSignal() {
        //playerId,x,y,objType
        super(int, int, int, IDynObjectType)
    }
}
}