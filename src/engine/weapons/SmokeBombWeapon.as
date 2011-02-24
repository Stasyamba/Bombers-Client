/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.IActivatableWeapon

public class SmokeBombWeapon extends ActivatableWeaponBase implements IActivatableWeapon{

     private var mapManager:IMapManager;

    public function SmokeBombWeapon(mapManager:IMapManager, charges:int = 3) {
        super(charges)
        this.mapManager = mapManager;
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
         if (!mapManager.canUseMap)
            return false;
        return _charges > 0 && mapManager.map.getBlock(x, y).canSetBomb();
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by)) return;
        _charges--;
        EngineContext.triedToActivateWeapon.dispatch(by.slot, x, y, BombType.SMOKE)
    }

    override public function get type():WeaponType {
        return WeaponType.SMOKE_BOMB_WEAPON;
    }

    public function activateStatic(b:IBomber, x:int, y:int):void {
    }
}
}
