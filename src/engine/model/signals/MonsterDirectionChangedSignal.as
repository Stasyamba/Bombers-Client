/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.utils.Direction

import org.osflash.signals.Signal

public class MonsterDirectionChangedSignal extends Signal {
    public function MonsterDirectionChangedSignal() {
        super(int, Number, Number, Direction)
    }
}
}
