/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.explosionss {
public class ExplosionType {

    public static const REGULAR:ExplosionType = new ExplosionType("REGULAR", 1, true, false);
    public static const NULL:ExplosionType = new ExplosionType("NULL", 0, true, false);
    public static const COMPLEX:ExplosionType = new ExplosionType("COMPLEX", 0, true, false);
    public static const ATOM:ExplosionType = new ExplosionType("ATOM", 3, true, true);
    public static const BOX:ExplosionType = new ExplosionType("BOX", 0, false, false);
    public static const DYNAMITE:ExplosionType = new ExplosionType("DYNAMITE", 2, true, false);


    public static function byValue(value:String):ExplosionType {
        switch (value) {
            case "REGULAR":return REGULAR;
            case "NULL":return NULL;
            case "ATOM":return ATOM;
            case "BOX":return BOX;
            case "DYNAMITE":return DYNAMITE;
        }
        throw new ArgumentError("Invalid explosion type value");
    }

    private var _printsPrints:Boolean
    private var _timeToLive:Number;
    private var _value:String;
    private var _printsEverywhere:Boolean;

    public function ExplosionType(value:String, timeToLive:Number, printsPrints:Boolean, printsEverywhere:Boolean) {
        _timeToLive = timeToLive;
        _value = value;
        _printsEverywhere = printsEverywhere;
        _printsPrints = printsPrints;
    }

    public function get value():String {
        return _value;
    }

    public function get timeToLive():Number {
        return _timeToLive;
    }

    public function get printsEverywhere():Boolean {
        return _printsEverywhere;
    }

    public function get printsPrints():Boolean {
        return _printsPrints
    }
}
}