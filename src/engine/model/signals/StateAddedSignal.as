/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.utils.ViewState

import org.osflash.signals.Signal

public class StateAddedSignal extends Signal {
    public function StateAddedSignal() {
        super(ViewState)
    }
}
}
