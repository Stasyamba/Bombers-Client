/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.medals {
public class MedalBase {

    private var _prizes:Array
    private var _text:String

    public function MedalBase(text:String, prizes:Array) {
        _prizes = prizes
        _text = text
    }

    public function get text():String {
        return _text
    }

    //ResourceObject,ExperienceObject,ItemProfileObject
    public function get prizes():Array {
        return _prizes
    }
}
}
