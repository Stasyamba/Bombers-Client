/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.resources {
public class ResourceAmount {

    private var _amount:int;
    private var _resType:ResourceType;

    public function get amount():int {
        return _amount;
    }

    public function get resType():ResourceType {
        return _resType;
    }

    public function ResourceAmount(amount:int, resType:ResourceType) {
        _amount = amount;
        _resType = resType;
    }
}
}
