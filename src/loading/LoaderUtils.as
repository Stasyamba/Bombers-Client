/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
public class LoaderUtils {
    public function LoaderUtils() {
    }

    public static function stringId(value:int):String {
        var s:String = String(value)
        if (s.length == 1) {
            return "0" + s
        }
        return s
    }
}
}
