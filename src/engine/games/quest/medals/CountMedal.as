/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
public class CountMedal extends MedalBase {

    private var _count:int
    private var _objectId:int

    public function CountMedal(text:String, prizes:Array, count:int, objectId:int) {
        super(text, prizes)
        _count = count
        _objectId = objectId
    }

    public function get count():int {
        return _count
    }

    public function get objectId():int {
        return _objectId
    }

}
}
