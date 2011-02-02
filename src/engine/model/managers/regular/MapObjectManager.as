/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IMapObject
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IObjectManager
import engine.model.managers.interfaces.IPlayerManager

import mx.collections.ArrayList

public class MapObjectManager implements IObjectManager {

    protected var playerManager:IPlayerManager;

    protected var mapManager:IMapManager;

    protected var _objects:ArrayList = new ArrayList();

    public function MapObjectManager(playerManager:IPlayerManager, mapManager:IMapManager) {
        this.playerManager = playerManager;
        this.mapManager = mapManager;
    }

    public function checkObjectTaken(elapsedMiliSecs:int):void {
        var l:int = _objects.length;
        for (var i:int = 0; i < l; i++) {
            var object:IMapObject = _objects.getItemAt(i) as IMapObject;
            if (playerManager.checkPlayerMetObject(object)) {
                object.tryToTake();
                EngineContext.triedToTakeObject.dispatch(object);
            }
        }
    }

    public function addObject(object:IMapObject):void {
        //todo: check bonuses in reg game
        //object.block.setObject(object);
        _objects.addItem(object);
        trace("added")
    }

    public function takeObject(x:int, y:int, player:IBomber):void {
        var object:IMapObject = getObjectAt(x, y);
        object.activateOn(player)
        object.block.collectObject(playerManager.myId == player.playerId);
        _objects.removeItem(object);
        trace("removed");
    }

    private function getObjectAt(x:int, y:int):IMapObject {
        for each (var object:IMapObject in _objects.source) {
            if (x == object.x && y == object.y)
                return object;
        }
        return null
    }
}
}