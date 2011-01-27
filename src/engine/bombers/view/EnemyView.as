/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.interfaces.IDestroyable
import engine.utils.Direction

public class EnemyView extends BomberViewBase implements IDestroyable {

    public function EnemyView(bomber:IEnemyBomber) {
        super(bomber);
        EngineContext.enemyInputDirectionChanged.add(inputDirectionChanged);
        EngineContext.enemySmoothMovePerformed.add(updateCoords)
        EngineContext.enemyDied.add(onEnemyDied);
    }

    private function inputDirectionChanged(id:int, x:Number, y:Number, dir:Direction):void {
        if (id == bomber.playerId && !bomber.isDead) {
            this.x = x;
            this.y = y;
            draw();
        }
    }

    private function updateCoords(id:int, x:int, y:int):void {

        if (id == bomber.playerId && !bomber.isDead) {
            this.x = x;
            this.y = y;
        }
    }

    private function get bomber():IEnemyBomber {
        return _bomber as IEnemyBomber;
    }

    public function destroy():void {
        EngineContext.enemyInputDirectionChanged.remove(inputDirectionChanged);
        EngineContext.enemySmoothMovePerformed.remove(updateCoords)
        EngineContext.enemyDied.remove(onEnemyDied);
    }

    protected function onEnemyDied(id:int):void {
        if (id == _bomber.playerId) {
            onDied();
            destroy();
        }
    }
}
}