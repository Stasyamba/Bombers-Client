/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package components.common.resources.resourcemarket {
import components.common.resources.ResourceType

public class ResourceExchangeRate {
    private var _sell:ResourceType;
    private var _buy:ResourceType;
    private var _sellAmount:int;
    private var _buyAmount:int;

    public function ResourceExchangeRate(sell:ResourceType, buy:ResourceType, sellAmount:int, buyAmount:int) {
        _sell = sell;
        _buy = buy;
        _sellAmount = sellAmount;
        _buyAmount = buyAmount;
    }

    public function get sell():ResourceType {
        return _sell;
    }

    public function get buy():ResourceType {
        return _buy;
    }

    public function get sellAmount():int {
        return _sellAmount;
    }

    public function get buyAmount():int {
        return _buyAmount;
    }
}
}
