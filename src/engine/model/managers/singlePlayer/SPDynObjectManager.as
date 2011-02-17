/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.DynObjectManager

public class SPDynObjectManager extends DynObjectManager {

    private var _enemiesManager:IEnemiesManager;

    public function SPDynObjectManager(playerManager:IPlayerManager, enemiesManager:IEnemiesManager, mapManager:IMapManager) {
        super(playerManager, mapManager)
        _enemiesManager = enemiesManager;
    }


    override public function checkObjectsActivated(elapsedMilliSecs:int):void {
        var l:int = _objects.length;
        for (var i:int = 0; i < l; i++) {
            var object:IDynObject = _objects.getItemAt(i) as IDynObject;
            if (object is ICollectableDynObject)
                checkCollectableObject(object as ICollectableDynObject)
            if (object is ITimeActivatableDynObject)
                checkTimeActivatedObject(object as ITimeActivatableDynObject, elapsedMilliSecs)
        }
        checkBuffer(elapsedMilliSecs)


    }

    private function checkTimeActivatedObject(object:ITimeActivatableDynObject, elapsedMilliSecs:int):void {
        object.onTimeElapsed(elapsedMilliSecs);
        if (object.timeToActivate <= 0) {
            activateObject(object.x, object.y, object.victim)
        }
    }

    private function checkCollectableObject(object:ICollectableDynObject):void {
        if (playerManager.checkPlayerMetObject(object)) {
            if (!object.wasTriedToBeTaken) {
                trace("player tried to take")
                object.tryToTake();
                EngineContext.objectActivated.dispatch(playerManager.myId, object.block.x, object.block.y, object.type);
            }
        }
        _enemiesManager.forEachAliveEnemy(function todo(enemy:IEnemyBomber, id:int) {
            if (_enemiesManager.checkEnemyTakenObject(enemy, object)) {
                if (!object.wasTriedToBeTaken) {
                    trace("enemie " + id + " tried to take")
                    object.tryToTake();
                    EngineContext.objectActivated.dispatch(id, object.block.x, object.block.y, object.type);
                }
            }
        })
    }

}
}
