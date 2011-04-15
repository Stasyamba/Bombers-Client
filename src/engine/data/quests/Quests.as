/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.data.quests {
import greensock.events.LoaderEvent
import greensock.loading.LoaderMax
import greensock.loading.XMLLoader
import greensock.loading.data.LoaderMaxVars
import greensock.loading.data.XMLLoaderVars

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
