/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.IActivatableWeapon

public class AtomBombWeapon implements IActivatableWeapon {

    private var _charges:int;
    private var mapManager:IMapManager;
    private var bombsBuilder:BombsBuilder;

    public function AtomBombWeapon(mapManager:IMapManager, bombsBuilder:BombsBuilder, charges:int = 3) {
        this.mapManager = mapManager;
        this.bombsBuilder = bombsBuilder;

        _charges = charges;
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by)) return;
        _charges--;
        EngineContext.triedToSetBomb.dispatch(x, y, BombType.ATOM)
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!mapManager.canUseMap)
            return false;
        return _charges > 0 && mapManager.map.getBlock(x, y).canSetBomb();
    }

    public function get type():WeaponType {
        return WeaponType.ATOM_BOMB_WEAPON;
    }


    public function activateStatic(b:IBomber, x:int, y:int):void {
    }

    public function get charges():int {
        return _charges
    }
}
}