/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.weapons {
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public class TriedToUseWeaponSignal extends Signal {
    public function TriedToUseWeaponSignal() {
        super(int, int, int, WeaponType);
    }
}
}