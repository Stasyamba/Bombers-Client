/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class WeaponActivatedSignal extends Signal {
    public function WeaponActivatedSignal() {
        super(int, int, int, WeaponType)
    }
}
}