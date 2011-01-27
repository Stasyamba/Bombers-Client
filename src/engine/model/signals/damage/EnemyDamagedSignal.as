/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.damage {
import org.osflash.signals.Signal

public class EnemyDamagedSignal extends Signal {
    public function EnemyDamagedSignal() {
        super(int, int)
    }
}
}