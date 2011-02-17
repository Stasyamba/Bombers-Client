/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IDynObject

import org.osflash.signals.Signal

public class TriedToActivateObjectSignal extends Signal {
    public function TriedToActivateObjectSignal() {
        super(IDynObject);
    }
}
}