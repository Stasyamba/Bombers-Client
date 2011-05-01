/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.goals {
import engine.games.quest.monsters.MonsterType

public class DefeatedMonsterObject {

    private var _slot:int
    private var _type:MonsterType

    public function DefeatedMonsterObject(slot:int, type:MonsterType) {
        _slot = slot
        _type = type
    }

    public function get slot():int {
        return _slot
    }

    public function get type():MonsterType {
        return _type
    }
}
}
