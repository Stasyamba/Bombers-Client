/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.shadows {
public class ShadowShape {

    public static const RECTANGLE:ShadowShape = new ShadowShape("rect")
    public static const ELLIPSE:ShadowShape = new ShadowShape("ell")

    private var _value:String

    function ShadowShape(value:String) {
        _value = value
    }

    public static function fromString(id:String):ShadowShape {
        switch (id) {
            case RECTANGLE._value:
                return RECTANGLE
            case ELLIPSE._value:
                return ELLIPSE
        }
        throw new Error("no shadow shape with id = " + id)
    }
}
}
