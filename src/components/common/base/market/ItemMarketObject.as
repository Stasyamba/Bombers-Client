package components.common.base.market {
import components.common.resources.ResourcePrice

public class ItemMarketObject {
    public var price:ResourcePrice = new ResourcePrice(0, 0, 0, 0);
    public var amount:int;
    //public discountList

    public function ItemMarketObject(priceP:ResourcePrice, amountP:int) {
        price.cloneFrom(priceP);
        amount = amountP;
    }
}
}