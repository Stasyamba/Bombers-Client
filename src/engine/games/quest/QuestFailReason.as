/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
public class QuestFailReason {

//    public static const DEATH:QuestFailReason = new QuestFailReason(0," Провал, твой бомбастер погиб. В следующий раз будь внимательнее! ")
//    public static const TIME:QuestFailReason = new QuestFailReason(1," Эх, чуть-чуть не успел! Шевели булками=)! ")
    public static const DEATH:QuestFailReason = new QuestFailReason(0, "DEATH")
    public static const TIME:QuestFailReason = new QuestFailReason(1, "TIME")

    private var _text:String
    private var _id:int

    public function QuestFailReason(id:int, text:String) {
        _id = id
        _text = text
    }


    public function get text():String {
        return _text
    }

    public function get id():int {
        return _id
    }
}
}
