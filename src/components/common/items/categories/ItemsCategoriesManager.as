package components.common.items.categories {
import components.common.items.ItemType

public class ItemsCategoriesManager {
    public function ItemsCategoriesManager() {
    }

    public function isBombBase(itemType:ItemType):Boolean {
        var res:Boolean = false;

        switch (itemType) {
            case ItemType.BASE_BOMB:
                res = true;
                break;

        }

        return res;
    }

    public function getItemCategory(itemType:ItemType):ItemCategory {
        var res:ItemCategory = null;

        switch (itemType) {
            case ItemType.AURA_FIRE:
                res = ItemCategory.AURA;
                break;

            case ItemType.QUEST_ITEM_CANARY:
            case ItemType.QUEST_ITEM_SNOWBOOTS:
            case ItemType.BASE_BOMB:
                res = ItemCategory.QUEST_ITEM;
                break;

            case ItemType.NUCLEAR_BOMB:
            case ItemType.X_RAY_BOMB:
            case ItemType.MINA_BOMB:
            case ItemType.HAMELEON_POISON:
            case ItemType.DINAMIT_BOMB:
            case ItemType.BOX_BOMB:
                res = ItemCategory.WEAPON;
                break;
        }

        return res;
    }

    public function getItemMarketCategory(itemType:ItemType):MarketCategory {
        var res:MarketCategory = MarketCategory.VARIOUS;

        switch (itemType) {
            case ItemType.AURA_FIRE:
            case ItemType.QUEST_ITEM_CANARY:
            case ItemType.QUEST_ITEM_SNOWBOOTS:
                res = MarketCategory.VARIOUS;
                break;

            case ItemType.NUCLEAR_BOMB:
            case ItemType.X_RAY_BOMB:
            case ItemType.HAMELEON_POISON:
            case ItemType.MINA_BOMB:
            case ItemType.DINAMIT_BOMB:
            case ItemType.BOX_BOMB:
                res = MarketCategory.BOMBS_AND_POISONS;
                break;
        }

        return res;
    }

    public function getAuraCategory(itemType:ItemType):AuraCategory {
        return null;
    }
}
}