/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusAddBomb extends BonusBase implements ICollectableDynObject {

    public function BonusAddBomb(block:IMapBlock) {
        super(block);
    }

    public override function activateOn(player:IBomber):void {
        super.activateOn(player)
        player.incBombCount();
        trace("player " + player.slot + " collected bonus bomb , bombs = " + player.bombCount);
    }

    public function get type():IDynObjectType {
        return BonusType.ADD_BOMB;
    }

}
}