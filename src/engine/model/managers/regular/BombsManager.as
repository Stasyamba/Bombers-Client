/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.EngineContext
import engine.bombss.interfaces.IBomb
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IBombsManager
import engine.model.managers.interfaces.IMapManager

import mx.collections.ArrayList

public class BombsManager implements IBombsManager {

    protected var _bombs:ArrayList = new ArrayList();
    protected var _mapManager:IMapManager;

    protected var readyToExplode:ArrayList = new ArrayList();
    protected var timeSinceLastExplosion:Number = 0;
    protected static const EXPLOSION_PERIOD:Number = 0.80;

    public function BombsManager(mapManager:IMapManager) {
        _mapManager = mapManager;
    }

    public function addBombAt(x:int, y:int, bomb:IBomb):void {
        var block:IMapBlock = _mapManager.map.getBlock(x, y);
        block.setBomb(bomb);
        _bombs.addItem(bomb);
    }

    public function getBombAt(x:int, y:int):IBomb {
        var block:IMapBlock = _mapManager.map.getBlock(x, y);
        return block.bomb;
    }

    public function checkBombs(elapsedMiliSecs:int):void {
        // do nothing, bombs are exploded manually, by server events
        var elapsedSecs:Number = elapsedMiliSecs / 1000;
        for each (var bomb:IBomb in _bombs.source) {
            bomb.onTimeElapsed(elapsedSecs);
        }
        checkBuffer(elapsedSecs);
    }

    public function explodeBombAt(x:int, y:int, power_bonus:int = 0):void {
        trace("bomb exploded at " + x + "," + y);
        var b:IBomb = getBombAt(x, y);
        b.power += power_bonus;
        _bombs.removeItem(b);
        readyToExplode.addItem(b);
    }

    protected function checkBuffer(elapsedSecs:Number):void {
        timeSinceLastExplosion += elapsedSecs;
        if (timeSinceLastExplosion >= EXPLOSION_PERIOD) {
            timeSinceLastExplosion -= EXPLOSION_PERIOD;
            if (readyToExplode.length > 0) {
                var expls:ArrayList = new ArrayList();
                for each (var b:IBomb in readyToExplode.source) {
                    expls.addItem(b.explode());
                    b.block.clearBomb();
                }
                readyToExplode.removeAll();
                EngineContext.explosionsAdded.dispatch(expls);
            }
        }
    }


}
}