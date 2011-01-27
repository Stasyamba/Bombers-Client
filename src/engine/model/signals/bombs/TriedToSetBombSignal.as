/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bombs {
import engine.bombss.BombType

import org.osflash.signals.Signal

public class TriedToSetBombSignal extends Signal {
    public function TriedToSetBombSignal() {
        super(int, int, BombType)
    }
}
}