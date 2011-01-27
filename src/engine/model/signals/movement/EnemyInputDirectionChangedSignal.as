/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.movement {
import engine.utils.Direction

import org.osflash.signals.Signal

public class EnemyInputDirectionChangedSignal extends Signal {
    public function EnemyInputDirectionChangedSignal() {
        super(int, Number, Number, Direction)
    }
}
}