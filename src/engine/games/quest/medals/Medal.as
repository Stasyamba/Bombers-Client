/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
import components.common.base.expirance.ExperianceObject
import components.common.items.ItemProfileObject
import components.common.items.ItemType
import components.common.resources.ResourceObject
import components.common.resources.ResourceType

public class Medal {

    public static const BRONZE:Medal = new Medal(1)
    public static const SILVER:Medal = new Medal(2)
    public static const GOLD:Medal = new Medal(4)

    private var _value:int

    public static function fromXml(xml:XML, medalType:String):MedalBase {
        switch (medalType) {
            case "time":
                return timeMedal(xml)
            case "count":
                return countMedal(xml)
        }
        throw new Error("no medal type named " + medalType)
    }

    private static function countMedal(xml:XML):MedalBase {
        return new CountMedal(xml.@text, prizes(xml), xml.@count, xml.@id)
    }

    private static function timeMedal(xml:XML):MedalBase {
        return new TimeMedal(xml.@text, prizes(xml), xml.@time)
    }

    private static function prizes(xml:XML):Array {
        var res:Array = new Array()
        for each (var r:XML in xml.Resource) {
            res.push(new ResourceObject(ResourceType.byId(r.id), r.val))
        }
        for each (var e:XML in xml.Experience) {
            res.push(new ExperianceObject(0, r.val))
        }
        for each (var o:XML in xml.Object) {
            res.push(new ItemProfileObject(ItemType.byValue(o.id), o.val))
        }
        return res
    }

    public function get value():int {
        return _value
    }

    public function Medal(value:int) {
        _value = value
    }
}
}
