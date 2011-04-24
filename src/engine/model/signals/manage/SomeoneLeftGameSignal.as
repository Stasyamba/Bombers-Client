/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.manage {
import engine.profiles.LobbyProfile

import org.osflash.signals.Signal

public class SomeoneLeftGameSignal extends Signal {
    public function SomeoneLeftGameSignal() {
        super(LobbyProfile);
    }
}
}