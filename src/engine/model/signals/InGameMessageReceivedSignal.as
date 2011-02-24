/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals {
import engine.profiles.LobbyProfile

import org.osflash.signals.Signal

public class InGameMessageReceivedSignal extends Signal {
    public function InGameMessageReceivedSignal() {
        super(LobbyProfile, String);
    }
}
}
