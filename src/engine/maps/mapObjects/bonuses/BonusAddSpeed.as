/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class BonusAddSpeed extends BonusBase implements IBonus {


    public function BonusAddSpeed(block:IMapBlock) {
        super(block);
    }


    public function activateOn(player:IBomber):void {
        player.gameSkills.speed *= 1.1;
        trace("player " + player.playerId + " collected bonus speed , speed = " + player.gameSkills.speed);
    }

    public function get type():IMapObjectType {
        return BonusType.ADD_SPEED;
    }

}
}