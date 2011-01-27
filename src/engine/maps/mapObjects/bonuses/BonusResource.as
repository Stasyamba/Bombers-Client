/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IBonus
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType
import engine.resources.ResourceAmount

public class BonusResource extends BonusBase implements IBonus {

    private var _amount:ResourceAmount;

    public function BonusResource(block:IMapBlock, amount:ResourceAmount) {
        super(block)
        _amount = amount;
    }

    public function activateOn(player:IBomber):void {
        throw new Error("implement adding resources")
    }

    public function get type():IMapObjectType {
        return BonusType.RESOURCE;
    }

    public function get amount():ResourceAmount {
        return _amount;
    }
}
}
