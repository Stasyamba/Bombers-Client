/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusAddSpeed extends BonusBase implements ICollectableDynObject {


    public function BonusAddSpeed(block:IMapBlock) {
        super(block);
    }


    public override function activateOn(player:IBomber):void {
        super.activateOn(player)
        player.incSpeed();
        trace("player " + player.slot + " collected bonus speed , speed = " + player.speed);
    }

    public function get type():IDynObjectType {
        return BonusType.ADD_SPEED;
    }

}
}