/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.manage {
import engine.profiles.GameProfile

import org.osflash.signals.Signal

public class GameProfileLoadedSignal extends Signal {
    public function GameProfileLoadedSignal() {
        super(GameProfile)
    }
}
}