/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import mx.collections.ArrayList

public class GameStats {

    private var _destroyedBlocks:ArrayList = new ArrayList();
    private var _collectedObjects:ArrayList = new ArrayList();
    private var _defeatedMonsters:ArrayList = new ArrayList();

    //array of DestroyedMapBlockObject
    public function get destroyedBlocks():ArrayList {
        return _destroyedBlocks;
    }

    //array of CollectedDOObject
    public function get collectedObjects():ArrayList {
        return _collectedObjects;
    }

    //array of DefeatedMonsterObject
    public function get defeatedMonsters():ArrayList {
        return _defeatedMonsters;
    }

    public function GameStats() {
    }
}
}
