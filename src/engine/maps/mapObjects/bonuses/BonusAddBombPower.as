/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class BonusAddBombPower extends BonusBase implements IBonus {


    public function BonusAddBombPower(block:IMapBlock) {
        super(block);
    }


    public function activateOn(player:IBomber):void {
        player.incBombPower();
        trace("player " + player.playerId + " collected bonus power , power = " + player.bombPower);
    }

    public function get type():IMapObjectType {
        return BonusType.ADD_BOMB_POWER;
    }

}
}