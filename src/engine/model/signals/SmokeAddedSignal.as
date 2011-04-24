/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import org.osflash.signals.Signal

public class SmokeAddedSignal extends Signal {
    public function SmokeAddedSignal() {
        super(int, int)
    }
}
}
