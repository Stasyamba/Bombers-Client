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

import engine.games.quest.goals.GoalsBuilder
import engine.games.quest.goals.IGoal

public class Medal {

    public static const BRONZE:Medal = new Medal(1,"BRONZE")
    public static const SILVER:Medal = new Medal(2,"SILVER")
    public static const GOLD:Medal = new Medal(4,"GOLD")

    private var _value:int
    private var _string:String

    public static function fromXml(xml:XML, commonGoal:IGoal = null):MedalBase {
        if (commonGoal != null)
            return timeMedal(xml, commonGoal)
        return countMedal(xml)
    }

    private static function countMedal(xml:XML):MedalBase {
        return new CountMedal(xml.@text, prizes(xml), GoalsBuilder.makeFromXml(xml.goal[0]))
    }

    private static function timeMedal(xml:XML, commonGoal:IGoal):MedalBase {
        return new TimeMedal(xml.@text, prizes(xml), commonGoal, xml.@time)
    }

    private static function prizes(xml:XML):Array {
        var res:Array = new Array()
        for each (var r:XML in xml.prize.Resource) {
            res.push(new ResourceObject(ResourceType.byId(r.id), r.val))
        }
        for each (var e:XML in xml.prize.Experience) {
            res.push(new ExperianceObject(0, r.val))
        }
        for each (var o:XML in xml.prize.Object) {
            res.push(new ItemProfileObject(ItemType.byValue(o.id), o.val))
        }
        return res
    }

    public function get value():int {
        return _value
    }

    public function get string():String {
        return _string
    }

    public function Medal(value:int,string:String) {
        _value = value
        _string = string
    }
}
}
