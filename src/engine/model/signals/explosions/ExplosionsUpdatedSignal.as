/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.explosions {
import engine.explosionss.interfaces.IExplosion

import org.osflash.signals.Signal

public class ExplosionsUpdatedSignal extends Signal {
    public function ExplosionsUpdatedSignal() {
        super(IExplosion)
    }
}
}