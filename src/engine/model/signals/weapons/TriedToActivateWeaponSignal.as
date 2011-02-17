/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.weapons {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class TriedToActivateWeaponSignal extends Signal {
    public function TriedToActivateWeaponSignal() {
        super(int, int, int, WeaponType);
    }
}
}