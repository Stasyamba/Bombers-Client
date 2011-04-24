/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.data.quests {
import loading.BombersContentLoader

public class Quests {

    public static function get questsNames():Array {
        return BombersContentLoader.questsNames
    }

    public static function questXml(questId:String):XML {
        return BombersContentLoader.questXML(questId)
    }
}
}
