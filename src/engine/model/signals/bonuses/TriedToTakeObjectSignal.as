/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bonuses {
import engine.maps.interfaces.IMapObject

import org.osflash.signals.Signal

public class TriedToTakeObjectSignal extends Signal {
    public function TriedToTakeObjectSignal() {
        super(IMapObject);
    }
}
}