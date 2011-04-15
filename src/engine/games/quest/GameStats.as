/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import mx.collections.ArrayList

public class GameStats {

    private var _destroyedBlocks:ArrayList = new ArrayList();
    private var _collectedObjects:ArrayList = new ArrayList();
    private var _defeatedEnemies:ArrayList = new ArrayList();

    public function get destroyedBlocks():ArrayList {
        return _destroyedBlocks;
    }

    public function get collectedObjects():ArrayList {
        return _collectedObjects;
    }

    public function get defeatedEnemies():ArrayList {
        return _defeatedEnemies;
    }

    public function GameStats() {
    }
}
}
