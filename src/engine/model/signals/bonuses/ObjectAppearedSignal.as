/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IMapObjectType

import org.osflash.signals.Signal

public class ObjectAppearedSignal extends Signal {
    public function ObjectAppearedSignal() {
        super(int, int, IMapObjectType)
    }
}
}