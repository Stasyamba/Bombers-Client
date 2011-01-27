/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.movement {
import engine.utils.Direction

import org.osflash.signals.Signal

public class PlayerInputDirectionChangedSignal extends Signal {
    public function PlayerInputDirectionChangedSignal() {
        super(Number, Number, Direction, Boolean)
    }
}
}