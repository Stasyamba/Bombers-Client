/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusExperience extends BonusBase implements ICollectableDynObject {

    private var _amount:int;

    public function BonusExperience(block:IMapBlock, amount:int) {
        super(block)
    }


    public override function activateOn(player:IBomber):void {
        throw new Error("implement adding experience")
    }

    public function get type():IDynObjectType {
        return BonusType.EXPERIENCE;
    }

    public function get amount():int {
        return _amount;
    }
}
}
