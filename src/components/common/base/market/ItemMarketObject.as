package components.common.base.market {
import components.common.resources.ResourcePrice

public class ItemMarketObject {
    public var price:ResourcePrice = new ResourcePrice(0, 0, 0, 0);
    public var amount:int;
    public var specialOffer:Boolean
    //public discountList

    public function ItemMarketObject(priceP:ResourcePrice, amountP:int,specialOffer:Boolean) {
        price.cloneFrom(priceP);
        amount = amountP;
        this.specialOffer = specialOffer
    }
}
}