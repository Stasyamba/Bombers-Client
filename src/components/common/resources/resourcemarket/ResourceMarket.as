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

    public static var GOLD_VOICES:Number = 0.25
    public static var CRYSTAL_VOICES:Number = 1
    public static var ADAMANTIUM_VOICES:Number = 4
    public static var ANTIMATTER_VOICES:Number = 8

    private var discounts:Array = new Array()
    private var exchangeRates:ArrayList = new ArrayList();

    public function setDiscounts(array:Array):void {
        discounts = array
    }

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

    private function getDiscount(rp:ResourcePrice):Number {
        var basePrice:Number = getBaseVoicePrice(rp)
        for (var i:int = 0; i < discounts.length; i++) {
            var object:Object = discounts[i];
            if (basePrice > object.moreThan) {
                return object.discount as Number
            }
        }
        return 0
    }

    public function getVoicePrice(rp:ResourcePrice):Number {
        var basePrice:Number = getBaseVoicePrice(rp)
        return basePrice - basePrice*getDiscount(rp)
    }

    public function getBaseVoicePrice(rp:ResourcePrice):Number {
        return (GOLD_VOICES * rp.gold.value + CRYSTAL_VOICES * rp.crystals.value + ADAMANTIUM_VOICES * rp.adamant.value + ANTIMATTER_VOICES * rp.antimatter.value)
    }

    public function getSliderStep(rt:ResourceType):int {
        if(rt == ResourceType.GOLD){
            if(GOLD_VOICES < 1)
                return int(1/GOLD_VOICES)
            return 1
        }
        if(rt == ResourceType.CRYSTALS){
            if(CRYSTAL_VOICES < 1)
                return int(1/CRYSTAL_VOICES)
            return 1
        }
        // adamant and antimatter > 1 voice per unit
        return 1
    }
}
}
