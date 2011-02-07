/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class BonusHeal extends BonusBase implements IBonus {

    public function BonusHeal(block:IMapBlock) {
        super(block)
    }

    public function activateOn(player:IBomber):void {
        //todo:replace 3 with profile property startLife
        if (player.life < 3)
            player.life += 1;
    }

    public function get type():IMapObjectType {
        return BonusType.HEAL;
    }


}
}