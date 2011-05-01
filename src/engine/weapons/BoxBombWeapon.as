/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.*

public class BoxBombWeapon extends ActivatableWeaponBase implements IActivatableWeapon {

    private var mapManager:IMapManager;

    public function BoxBombWeapon(mapManager:IMapManager, charges:int) {
        super(charges)
        this.mapManager = mapManager
    }

    public function activateStatic(x:int, y:int, by:IBomber):void {
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!mapManager.canUseMap)
            return false;
        return _charges > 0 && mapManager.map.getBlock(x, y).canSetBomb();
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        _charges--;
        EngineContext.triedToActivateWeapon.dispatch(by.slot, x, y, BombType.BOX)
    }

    public function qActivate(x:uint, y:uint, by:IBomber):void {
        _charges--
        qActivateStatic(x,y,by)
    }

    public function qActivateStatic(x:int, y:int,by:IBomber):void {
        EngineContext.qAddObject.dispatch(by.slot, x, y, BombType.BOX)
    }

    public override function get type():WeaponType {
        return WeaponType.BOX_BOMB_WEAPON;
    }
}
}
