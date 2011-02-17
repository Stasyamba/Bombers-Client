package components.common.items {
import components.common.base.access.rules.levelrule.AccessLevelRule
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
                [new AccessLevelRule(2)],

                new ItemViewObject(
                        ItemType.QUEST_ITEM_SNOWBOOTS,
                        ImagesPrefixes.QUEST_PREFIX + "snowBoots.png",
                        "Снегоступы",
                        "Снегоступы необходимы чтобы сражаться на гоных локациях"
                        )
                ));

        items.push(new ItemObject(
                ItemType.QUEST_ITEM_CANARY,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.QUEST_ITEM_CANARY,
                        ImagesPrefixes.QUEST_PREFIX + "canary.png",
                        "Разнюхивательная канарейка",
                        "Не заменима в шахтах для того чтобы не потеряться"
                        )
                ));

        /*** AURS ***/

        items.push(new ItemObject(
                ItemType.AURA_FIRE,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.AURA_FIRE,
                        ImagesPrefixes.AURS_PREFIX + "fireAura.png",
                        "Аура огня",
                        "Аура позволяет не теряя здоровья проходить по огненным элементам карты.",
                        ImagesPrefixes.AURS_PREFIX + "fireAuraAnotherImage.png"
                        )
                ));

        /*** BOMBS AND POISONS ***/


        items.push(new ItemObject(
                ItemType.HAMELEON_POISON,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.HAMELEON_POISON,
                        ImagesPrefixes.WEAPON_PREFIX + "hamelionPoison.png",
                        "Зелье хамелиона (увеличенное)",
                        "На 30 секунд ваш бомбастер сольется с картой и станет практически незаметным для ваших врагов!"
                        )
                ));

        items.push(new ItemObject(
                ItemType.NUCLEAR_BOMB,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.NUCLEAR_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "nuclearBomb.png",
                        "Ядерная бомба",
                        "Мощнейшая бомба, которая способна сокрушить на карте буквально все. Взрывная волна держится дольше обычного."
                        )
                ));

        items.push(new ItemObject(
                ItemType.X_RAY_BOMB,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.X_RAY_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "xrayBomb.png",
                        "Бомба рентген",
                        "Уничтожает только коробки в которымх могут находиться бонусы, не трогая при этом бомбастеров"
                        )
                ));

        items.push(new ItemObject(
                ItemType.MINA_BOMB,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.MINA_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "minaBomb.png",
                        "Мина",
                        "Вызрывается только после касания! Почувствуй себя стратегом, ставь ловушки, блокируй ходы соперников!"
                        )
                ));

        items.push(new ItemObject(
                ItemType.BOX_BOMB,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.BOX_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "boxBomb.png",
                        "Разбрасыватель",
                        "Когда вы спасаетесь от врагов, нет ничего лучше чем заградить им стенами! Почувствуй себя архитектором карты, мечи коробки!"
                        )
                ));


        items.push(new ItemObject(
                ItemType.DINAMIT_BOMB,
                [new AccessLevelRule(1)],

                new ItemViewObject(
                        ItemType.DINAMIT_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "dinamitBomb.png",
                        "Динамит",
                        "Мощная бомба которая снимает сразу 2 жизни. Подорви салаг."
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