/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.maps.interfaces.IMapObject
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.ObjectManager

public class SinglePlayerObjectManager extends ObjectManager {

    private var _enemiesManager:IEnemiesManager;

    public function SinglePlayerObjectManager(playerManager:IPlayerManager, enemiesManager:IEnemiesManager, mapManager:IMapManager) {
        super(playerManager, mapManager)
        _enemiesManager = enemiesManager;
    }


    override public function checkObjectTaken(elapsedMiliSecs:int):void {
        for (var i:int = 0; i < _objects.length; i++) {
            var object:IMapObject = _objects.getItemAt(i) as IMapObject;
            if (playerManager.checkPlayerMetObject(object)) {
                if (!object.wasTriedToBeTaken) {
                    trace("player tried to take")
                    object.tryToTake();
                    EngineContext.objectTaken.dispatch(playerManager.myId, object.block.x, object.block.y, object.type);
                }
            }

        }
        for (var i:int = 0; i < _objects.length; i++) {
            var object:IMapObject = _objects.getItemAt(i) as IMapObject;
            _enemiesManager.forEachAliveEnemy(function todo(enemy:IEnemyBomber, id:int) {
                if (_enemiesManager.checkEnemyTakenObject(enemy, object)) {
                    if (!object.wasTriedToBeTaken) {
                        trace("enemie " + id + " tried to take")
                        object.tryToTake();
                        EngineContext.objectTaken.dispatch(id, object.block.x, object.block.y, object.type);
                    }
                }
            })
        }
    }
}
}
