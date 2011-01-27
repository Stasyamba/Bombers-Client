/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.resources {
import mx.collections.ArrayList

public class ResourceMarket {

    private var exchangeRates:ArrayList = new ArrayList();

    public function convert(sell:ResourceAmount, buy:ResourceType):ResourceAmount {
        if (sell.resType == buy)
            return sell;
        var rate:ResourceExchangeRate = getRate(sell, buy);
        if (rate == null)
            throw new Error("No exchange rate to buy " + buy.name + " for " + sell.resType.name);
        if (sell.amount % rate.sellAmount != 0)
            throw new Error("Not a valid amount of resource to sell");
        return new ResourceAmount(int(Math.round(sell.amount / rate.sellAmount)) * rate.buyAmount, buy)
    }

    private function getRate(sell:ResourceAmount, buy:ResourceType):ResourceExchangeRate {
        for each (var rate:ResourceExchangeRate in exchangeRates.source) {
            if (rate.sell == sell.resType && rate.buy == buy) {
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
}
}
