/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import engine.games.quest.goals.GoalsBuilder
import engine.games.quest.medals.Medal
import engine.games.quest.medals.MedalBase

import mx.collections.ArrayCollection

public class QuestObject {

    private var _xml:XML

    private var _goals:ArrayCollection = new ArrayCollection()

    private var _goldMedal:MedalBase
    private var _silverMedal:MedalBase
    private var _bronzeMedal:MedalBase

    private var _timeLimit:int


    public var best:Array
    public var medalsEarned:int

    public function hasMedal(medal:Medal):Boolean {
        return (medalsEarned & medal.value) != 0
    }

    public function QuestObject(xml:XML) {
        _xml = xml;
        _goals = GoalsBuilder.array(xml.goals)
        var medalType:String = xml.medals.@type

        _bronzeMedal = Medal.fromXml(xml.medals.Bronze[0], medalType)
        _silverMedal = Medal.fromXml(xml.medals.Silver[0], medalType)
        _goldMedal = Medal.fromXml(xml.medals.Gold[0], medalType)

        _timeLimit = xml.timeLimit
    }

    [Bindable]
    public function get name():String {
        return _xml.name
    }

    [Bindable]
    public function get description():String {
        return _xml.description
    }

    public function get id():String {
        return _xml.id
    }

    [Bindable]
    public function get locationId():int {
        return int(_xml.location)
    }

    //array of IGoal. Exact types in engine.quest.goals
    [Bindable]
    public function get goals():ArrayCollection {
        return _goals
    }


    //seconds. zero means no limit
    [Bindable]
    public function get timeLimit():int {
        return _timeLimit
    }

    [Bindable]
    public function get goldMedal():MedalBase {
        return _goldMedal
    }

    [Bindable]
    public function get silverMedal():MedalBase {
        return _silverMedal
    }

    [Bindable]
    public function get bronzeMedal():MedalBase {
        return _bronzeMedal
    }

    public function get imageURL():String {
        return _xml.questImage
    }

    public function get previewImageURL():String {
        return _xml.previewImage
    }
}
}
