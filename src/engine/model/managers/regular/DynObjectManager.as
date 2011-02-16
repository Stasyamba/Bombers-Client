/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.managers.interfaces.IDynObjectManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager

import mx.collections.ArrayList

public class DynObjectManager implements IDynObjectManager {

    protected var playerManager:IPlayerManager;
    protected var mapManager:IMapManager;

    protected var _objects:ArrayList = new ArrayList();

    protected var readyToActivate:ArrayList = new ArrayList();
    protected var timeSinceLastExplosion:int = 0;
    protected static const EXPLOSION_PERIOD:int = 800;

    public function DynObjectManager(playerManager:IPlayerManager, mapManager:IMapManager) {
        this.playerManager = playerManager;
        this.mapManager = mapManager;
    }

    public function checkObjectsActivated(elapsedMilliSecs:int):void {
        var l:int = _objects.length;
        for (var i:int = 0; i < l; i++) {
            var object:IDynObject = _objects.getItemAt(i) as IDynObject;
            if (object is ICollectableDynObject)
                checkCollectableObject(object as ICollectableDynObject)
            if (object is ITimeActivatableDynObject)
                checkTimeActivatedObject(object as ITimeActivatableDynObject, elapsedMilliSecs)
            if (l > _objects.length) {
                i--;
                l--
            }
        }
        checkBuffer(elapsedMilliSecs)
    }

    private function checkCollectableObject(object:ICollectableDynObject):void {
        if (playerManager.checkPlayerMetObject(object)) {
            if (!object.wasTriedToBeTaken) {
                object.tryToTake();
                EngineContext.triedToActivateObject.dispatch(object);
            }
        }
    }

    public function addObject(object:IDynObject):void {
        _objects.addItem(object);
        trace("added")
    }

    public function activateObject(x:int, y:int, player:IBomber):void {
        var object:IDynObject = getObjectAt(x, y);
        if (object == null) {
            trace("OH MY GOD!!! NO OBJECT AT " + x + "," + y)
        }
        if (object is ITimeActivatableDynObject) {
            (object as ITimeActivatableDynObject).addVictim(player)
            readyToActivate.addItem(object)
        }
        else
            object.activateOn(player)

        if (object.removeAfterActivation)
            _objects.removeItem(object);
        trace("removed at " + x + "," + y);
    }

    private function getObjectAt(x:int, y:int):IDynObject {
        for each (var object:IDynObject in _objects.source) {
            if (x == object.x && y == object.y)
                return object;
        }
        return null
    }

    private function checkTimeActivatedObject(object:ITimeActivatableDynObject, elapsedMilliSecs:int):void {
        object.onTimeElapsed(elapsedMilliSecs);
    }

    protected function checkBuffer(elapsedMilliSecs:int):void {
        if (Context.game == null)
            return
        timeSinceLastExplosion += elapsedMilliSecs;
        if (timeSinceLastExplosion >= EXPLOSION_PERIOD) {
            timeSinceLastExplosion -= EXPLOSION_PERIOD;
            //todo:shit
            Context.game.explosionExchangeBuffer.length = 0
            if (readyToActivate.length > 0) {
                for each (var b:ITimeActivatableDynObject in readyToActivate.source) {
                    b.activateOn(b.victim)
                }
                readyToActivate.removeAll();
                if (Context.game.explosionExchangeBuffer.length > 0)
                    EngineContext.explosionGroupAdded.dispatch(Context.game.explosionExchangeBuffer);
            }
        }
    }

}
}