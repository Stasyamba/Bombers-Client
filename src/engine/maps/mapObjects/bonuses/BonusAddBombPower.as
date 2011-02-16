/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusAddBombPower extends BonusBase implements ICollectableDynObject {


    public function BonusAddBombPower(block:IMapBlock) {
        super(block);
    }


    public override function activateOn(player:IBomber):void {
        super.activateOn(player)
        player.incBombPower();
        trace("player " + player.playerId + " collected bonus power , power = " + player.bombPower);
    }

    public function get type():IDynObjectType {
        return BonusType.ADD_BOMB_POWER;
    }

}
}