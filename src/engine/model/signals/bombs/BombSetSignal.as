/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bombs {
import engine.bombss.BombType

import org.osflash.signals.Signal

public class BombSetSignal extends Signal {
    public function BombSetSignal() {
        super(int, int, int, BombType)
    }
}
}