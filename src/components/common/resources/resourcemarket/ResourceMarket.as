/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package components.common.resources.resourcemarket {
import components.common.resources.ResourceObject
import components.common.resources.ResourcePrice
import components.common.resources.ResourceType

import mx.collections.ArrayList

public class ResourceMarket {

    public static const GOLD_VOICES:int = 1
    public static const CRYSTAL_VOICES:int = 4
    public static const ADAMANTIUM_VOICES:int = 7
    public static const ANTIMATTER_VOICES:int = 15

    private var exchangeRates:ArrayList = new ArrayList();

    public function convert(sell:ResourceObject, buy:ResourceType):ResourceObject {
        if (sell.type == buy)
            return sell;
        var rate:ResourceExchangeRate = getRate(sell, buy);
        if (rate == null)
            throw new Error("No exchange rate to buy " + buy.name + " for " + sell.type.name);
        if (sell.value % rate.sellAmount != 0)
            throw new Error("Not a valid amount of resource to sell");
        return new ResourceObject(buy, int(Math.round(sell.value / rate.sellAmount)) * rate.buyAmount)
    }

    private function getRate(sell:ResourceObject, buy:ResourceType):ResourceExchangeRate {
        for each (var rate:ResourceExchangeRate in exchangeRates.source) {
            if (rate.sell == sell.type && rate.buy == buy) {
                return rate;
            }
        }
        return null;
    }

    public function addExchangeRate(rate:ResourceExchangeRate):void {
        exchangeRates.addItem(rate);
    }

    public function ResourceMarket() {
    }

    public function getVoicePrice(rp:ResourcePrice):int {
        return GOLD_VOICES * rp.gold.value + CRYSTAL_VOICES * rp.crystals.value + ADAMANTIUM_VOICES * rp.adamant.value + ANTIMATTER_VOICES * rp.antimatter.value
    }
}
}
