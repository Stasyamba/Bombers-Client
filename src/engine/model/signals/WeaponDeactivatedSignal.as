/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class WeaponDeactivatedSignal extends Signal {
    public function WeaponDeactivatedSignal() {
        super(int, WeaponType)
    }
}
}
