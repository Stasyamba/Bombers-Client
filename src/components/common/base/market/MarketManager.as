package components.common.base.market {
import components.common.items.ItemType
import components.common.resources.ResourcePrice

public class MarketManager {
    public function MarketManager() {
    }

    public function getItemPrice(itemType:ItemType):ResourcePrice {
        var res:ResourcePrice = new ResourcePrice(0, 0, 0, 0);

        switch (itemType) {
            case ItemType.QUEST_ITEM_SNOWBOOTS:
                res = new ResourcePrice(1, 1, 0, 0);
                break;
            default:
                res = new ResourcePrice(0, 5, 0, 1);
                break;
        }

        return res;
    }

}
}