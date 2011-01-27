package components.common.worlds.locations {
import components.common.utils.adjustcolor.Color
import components.common.utils.adjustcolor.ColorMatrixObject

public class LocationViewManager {

    public var locations:Array = new Array();

    public function LocationViewManager() {
        locations.push(new LocationViewObject(
                LocationType.WORLD1_GRASSFIELDS,
                "Минные поля",
                "Опасное место для начинающего бомбера. На этих полях пройдут ваши первые сражения, в которых вы докажете всем свое превосходство.",
                "http://www.vensella.ru/sd/grassFieldLocationEnterBG.png",
                "http://www.vensella.ru/eg/previewAbove/grassAbove.png",
                "http://www.vensella.ru/sd/previews/grassfieldsPreview.jpg",
                0xd1d1d1,
                new ColorMatrixObject(60, 0.6),
                new ColorMatrixObject(0, 0.8)
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_MINE,
                "Шахты",
                "Если у вас клаустрафобия не стоит даже близко соваться в темные шахтах полные отчаиных бойцов-психопатов внутри!",
                "http://www.vensella.ru/sd/previews/enter/mine.jpg",
                "",
                "http://www.vensella.ru/sd/previews/minePreview.jpg",
                0xd1d1d1,
                new ColorMatrixObject(10, 0.4),
                new ColorMatrixObject(0, 0.8)
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_CASTLE,
                "Подземелья замка",
                "Каждый день в подземельях этого замка проходят ожесточенные бои, где сотни воинов выяснют кто из них достоин звания короля!",
                "http://www.vensella.ru/sd/previews/enter/castle.jpg",
                "",
                "http://www.vensella.ru/sd/previews/castlePreview.jpg",
                0xd1d1d1,
                new ColorMatrixObject(50, 0.1),
                new ColorMatrixObject(0, 0.8)
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SNOWPEAK,
                "Горный хребет",
                "Сражения здесь проходят даже в неистовые снежные бури, только очень суровые бомберы вступают на эту землю!",
                "http://www.vensella.ru/sd/previews/enter/snow.jpg",
                "",
                "http://www.vensella.ru/sd/previews/snowpeakPreview.jpg",
                0xd1d1d1,
                new ColorMatrixObject(140, 0.3, new Color(0, 0, 0), 0, new Color(0, 10, 30)),
                new ColorMatrixObject(0, 0.8)
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SATTELITE,
                "Затерянный спутник",
                "Спутник который ушел с орбиты 20 лет назад, и вот он снова здесь. На его борту вас ждет шокирующая правда о бесконечном космосе и его обитателях.",
                "",
                "",
                "http://www.vensella.ru/sd/previews/sattelitePreview.jpg"
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SEA,
                "Нейтральные воды",
                "В морских глубинах никто не услышит ваших криков, здесь каждый вершит свои законы.",
                "http://www.vensella.ru/sd/previews/enter/sea.jpg",
                "",
                "http://www.vensella.ru/sd/previews/seaPreview.jpg",
                0xd1d1d1,
                new ColorMatrixObject(170, 1),
                new ColorMatrixObject(0, 0.8)
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_ROCKET,
                "Космодром",
                "Место отправки опытных бомберов в космические глубины. В предверии взлета можно сразиться с достойными сопрениками!",
                "http://www.vensella.ru/sd/previews/enter/rocket.jpg",
                "",
                "http://www.vensella.ru/sd/previews/rocketPreview.jpg")
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_MOON,
                "Обратная стороны луны",
                "Мало кому посчастливилось тут побывать. Самые опытные бойцы заступят на эту арену с великой гордостью.",
                "http://www.vensella.ru/sd/previews/enter/moon.jpg",
                "",
                "http://www.vensella.ru/sd/previews/moonPreview.jpg")
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_UFO,
                "SECRET BASE",
                "Информация о данном месте стого засекречена, просим вас забыть о существовании этой локации.",
                "",
                "",
                "http://www.vensella.ru/sd/previews/ufoPreview.jpg")
                );

    }

    public function getLocationViewObject(locationType:LocationType):LocationViewObject {
        var res:LocationViewObject = null;

        for each(var lvo:LocationViewObject in locations) {
            if (lvo.locationType == locationType) {
                res = lvo;
                break;
            }
        }

        return res;
    }
}
}