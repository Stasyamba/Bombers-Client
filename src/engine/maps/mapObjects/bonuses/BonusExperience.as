/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class BonusExperience extends BonusBase implements IBonus {

    private var _amount:int;

    public function BonusExperience(block:IMapBlock, amount:int) {
        super(block)
    }


    public function activateOn(player:IBomber):void {
        throw new Error("implement adding experience")
    }

    public function get type():IMapObjectType {
        return BonusType.EXPERIENCE;
    }

    public function get amount():int {
        return _amount;
    }
}
}
