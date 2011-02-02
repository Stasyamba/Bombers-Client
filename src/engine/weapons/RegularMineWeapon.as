/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.maps.builders.MapObjectBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.maps.mapObjects.MapObjectType
import engine.maps.mapObjects.mines.MineType
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IObjectManager
import engine.utils.greensock.TweenMax
import engine.weapons.interfaces.IMineWeapon

public class RegularMineWeapon implements IMineWeapon {

    private var _charges:int;
    private var _mapManager:IMapManager;
    private var _objectBuilder:MapObjectBuilder;
    private var _objectManager:IObjectManager;

    private static var INITIALIZE_TIME:Number = 2.0;

    public function RegularMineWeapon(charges:int, mapManager:IMapManager, objectBuilder:MapObjectBuilder, objectManager:IObjectManager) {
        _charges = charges
        _mapManager = mapManager
        _objectBuilder = objectBuilder
        _objectManager = objectManager
    }

    public function explode():void {
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!_mapManager.canUseMap)
            return false;
        var block:IMapBlock = _mapManager.map.getBlock(x, y);
        return block.canSetBomb() && (block.bomb.type == BombType.NULL) && (block.object.type == MapObjectType.NULL) && (charges > 0);
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by))
            return;
        var block:IMapBlock = _mapManager.map.getBlock(x, y);
        var mine:IMapObject = _objectBuilder.make(MineType.REGULAR, block)
        _charges--;
        block.setObject(mine);
        TweenMax.delayedCall(INITIALIZE_TIME, function():void {
            _objectManager.addObject(mine);
        })
    }

    public function get charges():int {
        return _charges;
    }

    public function get type():WeaponType {
        return WeaponType.REGULAR_MINE;
    }
}

}
