/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.special {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.bonuses.BonusBase

public class SpecialObject extends BonusBase implements ICollectableDynObject {

    private var _type:IDynObjectType

    public function SpecialObject(block:IMapBlock, type:SpecialObjectType) {
        super(block);
    }

    public override function activateOn(player:IBomber):void {
        super.activateOn(player)
        player.incBombCount();
        trace("player " + player.slot + " collected bonus bomb , bombs = " + player.bombCount);
    }

    public function get type():IDynObjectType {
        return _type;
    }

}
}
