/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class WeaponUsedSignal extends Signal {
    public function WeaponUsedSignal() {
        super(int, int, int, WeaponType)
    }
}
}