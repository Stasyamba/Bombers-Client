/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class BonusAddBomb extends BonusBase implements IBonus {


    public function BonusAddBomb(block:IMapBlock) {
        super(block);
    }


    public function activateOn(player:IBomber):void {
        player.incBombCount();
        trace("player " + player.playerId + " collected bonus bomb , bombs = " + player.bombCount);
    }

    public function get type():IMapObjectType {
        return BonusType.ADD_BOMB;
    }

}
}