/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IMapObjectType

import org.osflash.signals.Signal

public class ObjectTakenSignal extends Signal {
    public function ObjectTakenSignal() {
        super(int, int, int, IMapObjectType)
    }
}
}