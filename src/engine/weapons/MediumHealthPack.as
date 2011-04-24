/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.bombers.interfaces.IBomber
import engine.weapons.interfaces.IActivatableWeapon

public class MediumHealthPack extends ActivatableWeaponBase implements IActivatableWeapon {
    public function MediumHealthPack(charges:int) {
        super(charges)
    }

    public static const HEALING_POWER:int = 2;

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        return _charges > 0 && by.life < by.startLife
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        by.life = by.life + HEALING_POWER > by.startLife ? by.startLife : by.life + HEALING_POWER
    }

    public function activateStatic(b:IBomber, x:int, y:int):void {
        activate(x, y, b)
    }

    public override function get type():WeaponType {
        return WeaponType.MEDIUM_HEALTH_PACK_WEAPON;
    }
}
}
