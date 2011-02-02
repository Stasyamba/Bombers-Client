/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.weapons.interfaces.*;
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.model.managers.interfaces.IMapManager
import engine.weapons.WeaponType

public class BoxBombWeapon implements IActivatableWeapon {

    private var _charges:int;
    private var mapManager:IMapManager;
    private var bombsBuilder:BombsBuilder;

    public function BoxBombWeapon( mapManager:IMapManager, bombsBuilder:BombsBuilder, charges:int) {
        _charges = charges
        this.mapManager = mapManager
        this.bombsBuilder = bombsBuilder
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!mapManager.canUseMap)
            return false;
        return _charges > 0 && mapManager.map.getBlock(x, y).canSetBomb();
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by)) return;
        _charges--;
        EngineContext.triedToSetBomb.dispatch(x, y, BombType.BOX)
    }

    public function get charges():int {
        return _charges
    }

    public function get type():WeaponType {
        return WeaponType.BOX_BOMB_WEAPON;
    }
}
}
