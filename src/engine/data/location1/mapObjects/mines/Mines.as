/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.data.location1.mapObjects.mines {
import flash.display.Bitmap
import flash.display.BitmapData

public class Mines {

    private static var regular:Bitmap;

    [Embed(source="../../images/mines/regular.png")]
    public static const REGULAR_CLASS:Class;

    public static function get REGULAR():BitmapData {
        if (regular == null)
            regular = new REGULAR_CLASS() as Bitmap;
        return regular.bitmapData;
    }
}
}
