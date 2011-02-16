/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.profiles.GameProfile

import org.osflash.signals.Signal

public class ProfileLoadedSignal extends Signal {
    public function ProfileLoadedSignal() {
        super(GameProfile)
    }
}
}
