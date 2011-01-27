/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.movement {
import engine.utils.Direction

import org.osflash.signals.Signal

public class PlayerViewDirectionChangedSignal extends Signal {
    public function PlayerViewDirectionChangedSignal() {
        super(Number, Number, Direction)
    }
}
}