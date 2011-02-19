/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.manage {
import com.smartfoxserver.v2.entities.User

import engine.profiles.LobbyProfile

import org.osflash.signals.Signal

public class SomeoneLeftGameSignal extends Signal {
    public function SomeoneLeftGameSignal() {
        super(LobbyProfile);
    }
}
}