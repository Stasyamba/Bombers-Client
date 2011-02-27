package components.common.resources {
import flash.display.Bitmap

import mx.core.BitmapAsset

public class ResourceViewManager {

    public static const IMAGE_TYPE_BIG:int = 0;
    public static const IMAGE_TYPE_SMALL:int = 1;

    [Embed(source="assets/pageworld/toppanel/resources/resourceAdamantBig.png")]
    public static var resourceAdamantBig:Class;

    [Embed(source="assets/pageworld/toppanel/resources/resourceAdamantSmall.png")]
    public static var resourceAdamantSmall:Class;


    [Embed(source="assets/pageworld/toppanel/resources/resourceGoldBig.png")]
    public static var resourceGoldBig:Class;

    [Embed(source="assets/pageworld/toppanel/resources/resourceGoldSmall.png")]
    public static var resourceGoldSmall:Class;


    [Embed(source="assets/pageworld/toppanel/resources/resourceCrystalsBig.png")]
    public static var resourceCrystalsBig:Class;

    [Embed(source="assets/pageworld/toppanel/resources/resourceCrystalsSmall.png")]
    public static var resourceCrystalsSmall:Class;


    [Embed(source="assets/pageworld/toppanel/resources/resourceAntimatterBig.jpg")]
    public static var resourceAntimatterBig:Class;

    [Embed(source="assets/pageworld/toppanel/resources/resourceAntimatterSmall.png")]
    public static var resourceAntimatterSmall:Class;

    private var resources:Array = new Array();


    public function ResourceViewManager() {
        resources.push(new ResourceViewObject(
                ResourceType.GOLD,
                "Золото",
                "Золото – драгоценный метал, встречащийся на всех картах. Требуется для изоготовления практически любого оружия.",
                0xffd307,
                getImage(ResourceType.GOLD, IMAGE_TYPE_SMALL),
                getImage(ResourceType.GOLD, IMAGE_TYPE_BIG)
                ));

        resources.push(new ResourceViewObject(
                ResourceType.CRYSTALS,
                "Кристаллы",
                "Кристалы – редкая драгоценная порода камней. Добываются не на всех локациях. Требуются для изготовления оружия посерьезнее.",
                0xa70ec2,
                getImage(ResourceType.CRYSTALS, IMAGE_TYPE_SMALL),
                getImage(ResourceType.CRYSTALS, IMAGE_TYPE_BIG)
                ));

        resources.push(new ResourceViewObject(
                ResourceType.ADAMANT,
                "Адамантий",
                "Редчайший метал невеорятной прочности, он спобоен резать сталь как масло. Добывается только на паре локаций.",
                0xf6f6f6,
                getImage(ResourceType.ADAMANT, IMAGE_TYPE_SMALL),
                getImage(ResourceType.ADAMANT, IMAGE_TYPE_BIG)
                ));


        resources.push(new ResourceViewObject(
                ResourceType.ANTIMATTER,
                "Антиматерия",
                "Самый редкий ресурс в игре. Добывается только в космических глубинах. С помощью него вы сможете создать мощнейшие виды оружия во вселенной.",
                0x6bd6ee,
                getImage(ResourceType.ANTIMATTER, IMAGE_TYPE_SMALL),
                getImage(ResourceType.ANTIMATTER, IMAGE_TYPE_BIG)
                ));
    }

    public function getResource(resourceType:ResourceType):ResourceViewObject {
        var res:ResourceViewObject = null;

        for each(var r:ResourceViewObject in resources) {
            if (r.type == resourceType) {
                res = r;
                break;
            }
        }

        return res;
    }

    private function getImage(resourceType:ResourceType, imageType:int):Bitmap {
        var linkToClass:String = "";

        switch (resourceType) {
            case ResourceType.GOLD:
                linkToClass = "resourceGold";
                break;

            case ResourceType.CRYSTALS:
                linkToClass = "resourceCrystals";
                break;

            case ResourceType.ADAMANT:
                linkToClass = "resourceAdamant";
                break;

            case ResourceType.ANTIMATTER:
                linkToClass = "resourceAntimatter";
                break;

            default:
                break;

        }

        switch (imageType) {
            case IMAGE_TYPE_BIG:
                linkToClass += "Big";
                break;

            case IMAGE_TYPE_SMALL:
                linkToClass += "Small";
                break;

            default:
                break;
        }

        var bmp:Bitmap = null;

        if (linkToClass != "") {
            var bmpAsset:BitmapAsset = new ResourceViewManager[linkToClass]() as BitmapAsset;
            bmp = new Bitmap(bmpAsset.bitmapData);
        }

        return bmp;
    }
}
}