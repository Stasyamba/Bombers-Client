/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.manage {
import org.osflash.signals.Signal

public class RoomAddedSignal extends Signal {
    public function RoomAddedSignal() {
        super(int, String)
    }
}
}