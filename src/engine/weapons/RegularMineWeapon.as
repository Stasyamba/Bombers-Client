/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.maps.mapObjects.DynObjectType
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.IMineWeapon

public class RegularMineWeapon extends ActivatableWeaponBase implements IMineWeapon {

    private var _mapManager:IMapManager;

    private static var INITIALIZE_TIME:int = 2000;

    public function RegularMineWeapon(charges:int, mapManager:IMapManager) {
        super(charges)
        _mapManager = mapManager
    }

    public function activateStatic(b:IBomber, x:int, y:int):void {
    }

    public function explode():void {
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!_mapManager.canUseMap)
            return false;
        var block:IMapBlock = _mapManager.map.getBlock(x, y);
        return block.canSetBomb() && (block.object.type == DynObjectType.NULL) && (charges > 0);
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        //todo: remove this. it's all gonna be handled by game object
//        if (!canActivate(x, y, by))
//            return;
//        var block:IMapBlock = _mapManager.map.getBlock(x, y);
//        var mine:IDynObject = _objectBuilder.make(MineType.REGULAR, block)
//        _charges--;
//        block.setObject(mine);
//        TweenMax.delayedCall(INITIALIZE_TIME, function():void {
//            _objectManager.addObject(mine);
//        })
    }

    public override function get type():WeaponType {
        return WeaponType.REGULAR_MINE;
    }
}

}
