/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IDynObjectType

import org.osflash.signals.Signal

public class ObjectActivatedSignal extends Signal {
    public function ObjectActivatedSignal() {
        super(int, int, int, IDynObjectType)
    }
}
}