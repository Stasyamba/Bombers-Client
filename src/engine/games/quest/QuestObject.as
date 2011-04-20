/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
public class QuestObject {
    private var _xml:XML

    public function QuestObject(xml:XML) {
        _xml = xml;
    }

    public function get name():String {
        return _xml.name
    }

    public function get description():String {
        return _xml.description
    }

    public function get locationId():int {
        return int(_xml.location)
    }
}
}
