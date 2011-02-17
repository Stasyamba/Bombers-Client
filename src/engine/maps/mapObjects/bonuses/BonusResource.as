/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import components.common.resources.ResourceObject

import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusResource extends BonusBase implements ICollectableDynObject {

    private var _amount:ResourceObject;

    public function BonusResource(block:IMapBlock, amount:ResourceObject) {
        super(block)
        _amount = amount;
    }

    public override function activateOn(player:IBomber):void {
        throw new Error("implement adding resources")
    }

    public function get type():IDynObjectType {
        return BonusType.RESOURCE;
    }

    public function get amount():ResourceObject {
        return _amount;
    }
}
}
