/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
public class BigObjectLayer {

    public static const DECORATION:BigObjectLayer = new BigObjectLayer("decoration")
    public static const LOWER:BigObjectLayer = new BigObjectLayer("lower")
    public static const HIGHER:BigObjectLayer = new BigObjectLayer("higher")

    private var _value:String

    public function BigObjectLayer(value:String) {
        _value = value
    }

    public static function fromString(id:String):BigObjectLayer {
        switch (id) {
            case DECORATION._value:
                return DECORATION
            case LOWER._value:
                return LOWER
            case HIGHER._value:
                return HIGHER
        }
        throw new Error("no layer with name" + id)
    }
}
}
