/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class WeaponUnitSpentSignal extends Signal {
    public function WeaponUnitSpentSignal() {
        super(WeaponType)
    }
}
}
