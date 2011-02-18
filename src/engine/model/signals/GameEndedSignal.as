/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals {
import org.osflash.signals.Signal

public class GameEndedSignal extends Signal {
    public function GameEndedSignal() {
        super(String, int);
    }
}
}