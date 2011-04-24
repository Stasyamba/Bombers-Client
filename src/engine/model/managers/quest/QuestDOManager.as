/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.EngineContext
import engine.games.quest.monsters.Monster
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.DynObjectManager

public class QuestDOManager extends DynObjectManager {

    private var _monstersManager:MonstersManager;

    public function QuestDOManager(playerManager:IPlayerManager, monstersManager:MonstersManager, mapManager:IMapManager) {
        super(playerManager, mapManager)
        _monstersManager = monstersManager;
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
                EngineContext.objectActivated.dispatch(playerManager.mySlot, object.block.x, object.block.y, object.type);
            }
        }
        _monstersManager.forEachAliveMonster(function todo(monster:Monster, id:int) {
            if (_monstersManager.checkMonsterTakenObject(monster, object)) {
                if (!object.wasTriedToBeTaken) {
                    trace("monster " + id + " tried to take")
                    object.tryToTake();
                    EngineContext.objectActivated.dispatch(id, object.block.x, object.block.y, object.type);
                }
            }
        })
    }

}
}
