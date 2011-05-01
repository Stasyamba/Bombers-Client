/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.IActivatableWeapon

public class SmokeBombWeapon extends ActivatableWeaponBase implements IActivatableWeapon {

    private var mapManager:IMapManager;

    public function SmokeBombWeapon(mapManager:IMapManager, charges:int = 3) {
        super(charges)
        this.mapManager = mapManager;
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!mapManager.canUseMap)
            return false;
        return _charges > 0;
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by)) return;
        _charges--;
        EngineContext.smokeAdded.dispatch(x, y)
    }

    override public function get type():WeaponType {
        return WeaponType.SMOKE_BOMB_WEAPON;
    }

    public function activateStatic(x:int, y:int, by:IBomber):void {
        EngineContext.smokeAdded.dispatch(x, y)
    }

    public function qActivate(x:uint, y:uint, by:IBomber):void {
        _charges--;
        qActivateStatic(x, y, by)
    }

    public function qActivateStatic(x:int, y:int, by:IBomber):void {
        EngineContext.smokeAdded.dispatch(x, y)
    }
}
}
