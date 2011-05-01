/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.EngineContext
import engine.games.quest.monsters.Monster
import engine.interfaces.IDestroyable
import engine.utils.Direction

public class MonsterView extends CreatureViewBase implements IDestroyable {

    public function MonsterView(monster:Monster) {
        super(monster);
        EngineContext.qMonsterDirectionChanged.add(directionChanged);
        EngineContext.qMonsterCoordsChanged.add(updateCoords)
        EngineContext.qMonsterDied.add(onMonsterDied);
    }

    private function directionChanged(slot:int, x:Number, y:Number, dir:Direction):void {
        if (slot == monster.slot && !monster.isDead) {
            this.x = x;
            this.y = y;
            draw();
        }
    }

    private function updateCoords(slot:int, x:int, y:int):void {

        if (slot == monster.slot && !monster.isDead) {
            this.x = x;
            this.y = y;
        }
    }

    private function get monster():Monster {
        return _creature as Monster;
    }

    public function destroy():void {
        EngineContext.enemyInputDirectionChanged.remove(directionChanged);
        EngineContext.enemySmoothMovePerformed.remove(updateCoords)
        EngineContext.enemyDied.remove(onMonsterDied);
    }

    protected function onMonsterDied(m:Monster):void {
        if (m.slot == monster.slot) {
            onDied();
            destroy();
        }
    }
}
}
