/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.bombss.interfaces.IBomb
import engine.model.managers.interfaces.IBombsManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.regular.BombsManager

public class SinglePlayerBombsManager extends BombsManager implements IBombsManager {


    public function SinglePlayerBombsManager(mapManager:IMapManager) {
        super(mapManager);
    }

    override public function checkBombs(elapsedMiliSecs:int):void {
        var elapsedSecs:Number = elapsedMiliSecs / 1000;

        var l:int = _bombs.length;
        for (var i:int = 0; i < l; i++) {
            var bomb:IBomb = _bombs.getItemAt(i) as IBomb;
            bomb.onTimeElapsed(elapsedSecs);
            if (bomb.exploded) {
                explodeBombAt(bomb.block.x, bomb.block.y);
                l--;
                i--;
            }
        }
        checkBuffer(elapsedSecs);
    }

}
}