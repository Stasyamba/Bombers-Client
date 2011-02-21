package components.common.base.market {
import components.common.items.ItemType
import components.common.resources.ResourcePrice

public class MarketManager {

    private var _itemPrices:Array = new Array()

    public function MarketManager() {
    }

    public function setItemPrices(prices:Array):void {
        _itemPrices = prices
    }


    public function getItemPrice(itemType:ItemType):ResourcePrice {
        if (_itemPrices[itemType.value] != null)
            return  _itemPrices[itemType.value]
        return new ResourcePrice(1,0,0,0)
    }
}
}