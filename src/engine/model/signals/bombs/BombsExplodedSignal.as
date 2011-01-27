/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.bombs {
import org.osflash.signals.Signal

public class BombsExplodedSignal extends Signal {
    public function BombsExplodedSignal() {
        super(int, int, int);
    }
}
}