package components.common.items {
import components.common.base.server.ImagesPrefixes

public class ItemsManager {
    private var items:Array;

    public function ItemsManager() {
        items = new Array();

        items.push(new ItemObject(
                ItemType.BASE_BOMB,
                [],

                new ItemViewObject(
                        ItemType.BASE_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "baseBomb.png",
                        "Базовая бомба",
                        "",
                        ""
                        )
                ));

        items.push(new ItemObject(
                ItemType.QUEST_ITEM_SNOWBOOTS,
                [],

                new ItemViewObject(
                        ItemType.QUEST_ITEM_SNOWBOOTS,
                        ImagesPrefixes.QUEST_PREFIX + "snowBoots.png",
                        "Снегоступы",
                        "Снегоступы необходимы, чтобы сражаться на горных локациях"
                        )
                ));

        items.push(new ItemObject(
                ItemType.QUEST_ITEM_CANARY,
                [],

                new ItemViewObject(
                        ItemType.QUEST_ITEM_CANARY,
                        ImagesPrefixes.QUEST_PREFIX + "canary.png",
                        "Разнюхивательная канарейка",
                        "Незаменима в шахтах для того, чтобы не потеряться"
                        )
                ));

        /*** AURS ***/

        items.push(new ItemObject(
                ItemType.AURA_FIRE,
                [],

                new ItemViewObject(
                        ItemType.AURA_FIRE,
                        ImagesPrefixes.AURS_PREFIX + "fireAura.png",
                        "Аура огня",
                        "Аура позволяет, не теряя здоровья, проходить по огненным элементам карты.",
                        ImagesPrefixes.AURS_PREFIX + "fireAuraAnotherImage.png"
                        )
                ));

        /*** BOMBS AND POISONS ***/

		
		items.push(new ItemObject(
			ItemType.HEALTH_PACK_POISON,
			[],
			
			new ItemViewObject(
				ItemType.HEALTH_PACK_POISON,
				ImagesPrefixes.WEAPON_PREFIX + "healthPackPoison.png",
				"Зелье здоровья",
				"Приятное на вкус, бодрящее зелье. Хороший бой и 1 единица здоровья вам гарантированы."
			)
		));
		
		items.push(new ItemObject(
			ItemType.NUCLEAR_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.NUCLEAR_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "nuclearBomb.png",
				"Ядерная бомба",
				"Мощнейшая бомба, которая способна сокрушить на карте буквально все. Взрывная волна держится дольше обычного."
			)
		));
		
		items.push(new ItemObject(
			ItemType.HEALTH_PACK_ADVANCED_POISON,
			[],
			
			new ItemViewObject(
				ItemType.HEALTH_PACK_ADVANCED_POISON,
				ImagesPrefixes.WEAPON_PREFIX + "healthPackAdvancedPoison.png",
				"Зелье здоровья (увеличенное)",
				"Редчайшая выжимка из ночного опоссума, восстанавливает целых 2 единицы здоровья."
			)
		));
		
		items.push(new ItemObject(
			ItemType.SMOKE_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.SMOKE_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "smokeBomb.png",
				"Дымовая бомба",
				"Задыми всю карту, передвигайся как тень и верши свое правосудие в суде неравных"
			)
		));

        items.push(new ItemObject(
                ItemType.HAMELEON_POISON,
                [],

                new ItemViewObject(
                        ItemType.HAMELEON_POISON,
                        ImagesPrefixes.WEAPON_PREFIX + "hamelionPoison.png",
                        "Зелье хамелеона",
                        "На 30 секунд ваш бомбастер сольется с картой и станет практически незаметным для ваших врагов!"
                        )
                ));


       /* items.push(new ItemObject(
                ItemType.X_RAY_BOMB,
                [],

                new ItemViewObject(
                        ItemType.X_RAY_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "xrayBomb.png",
                        "Бомба рентген",
                        "Уничтожает только коробки, в которымх могут находиться бонусы, не трогая при этом бомбастеров"
                        )
                ));*/

        items.push(new ItemObject(
                ItemType.MINA_BOMB,
                [],

                new ItemViewObject(
                        ItemType.MINA_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "minaBomb.png",
                        "Мина",
                        "Вызрывается только после касания! Почувствуй себя стратегом, ставь ловушки и блокируй ходы соперников!"
                        )
                ));

       /* items.push(new ItemObject(
                ItemType.BOX_BOMB,
                [],

                new ItemViewObject(
                        ItemType.BOX_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "boxBomb.png",
                        "Разбрасыватель",
                        "Когда вы спасаетесь от врагов, нет ничего лучше чем заградить их путь стенами! Почувствуй себя архитектором карты, мечи коробки!"
                        )
                ));*/


        items.push(new ItemObject(
                ItemType.DINAMIT_BOMB,
                [],

                new ItemViewObject(
                        ItemType.DINAMIT_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "dinamitBomb.png",
                        "Динамит",
                        "Мощная бомба, которая снимает сразу 2 жизни. Подорви салаг."
                        )
                ));


    }

    public function getItem(itemType:ItemType):ItemObject {
        var res:ItemObject = null
        for each(var io:ItemObject in items) {
            if (io.type == itemType) {
                res = io;
                break;
            }
        }

        return res;
    }

    public function getItems():Array {
        return items;
    }
}
}