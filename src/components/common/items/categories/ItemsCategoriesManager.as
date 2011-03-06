package components.common.items.categories {
import components.common.items.ItemType;

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
			case ItemType.PART_BLACK_PAPER:
			case ItemType.PART_BOOTS:
			case ItemType.PART_CAP:
			case ItemType.PART_GENERATOR:
			case ItemType.PART_GLOVES:
			case ItemType.PART_MAGIC_SNOW:
			case ItemType.PART_ULTRA_RAY:
				res = ItemCategory.PART;
				break;
			
            case ItemType.AURA_FIRE:
			case ItemType.AURA_WARM_NIGHT:
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
			case ItemType.HEALTH_PACK_ADVANCED_POISON:
			case ItemType.HEALTH_PACK_POISON:
			case ItemType.SMOKE_BOMB:
                res = ItemCategory.WEAPON;
                break;
        }

        return res;
    }

    public function getItemMarketCategory(itemType:ItemType):MarketCategory {
        var res:MarketCategory = null;// = MarketCategory.VARIOUS;

        switch (itemType) {
            case ItemType.AURA_FIRE:
            case ItemType.QUEST_ITEM_CANARY:
            case ItemType.QUEST_ITEM_SNOWBOOTS:
                res = MarketCategory.VARIOUS;
                break;

            case ItemType.NUCLEAR_BOMB:
            case ItemType.HAMELEON_POISON:
            case ItemType.MINA_BOMB:
            case ItemType.DINAMIT_BOMB:
			case ItemType.HEALTH_PACK_ADVANCED_POISON:
			case ItemType.HEALTH_PACK_POISON:
			case ItemType.SMOKE_BOMB:
                res = MarketCategory.BOMBS_AND_POISONS;
                break;
        }

		//case ItemType.X_RAY_BOMB:
		//case ItemType.BOX_BOMB:
		
        return res;
    }

    public function getAuraCategory(itemType:ItemType):AuraCategory {
        return null;
    }
}
}