/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data.common.bombs {
import flash.display.Bitmap
import flash.display.BitmapData

public class Bombs {


    private static var blueGlowBitmap:Bitmap;
    private static var orangeGlowBitmap:Bitmap;
    private static var pinkGlowBitmap:Bitmap;
    private static var redGlowBitmap:Bitmap;


    [Embed(source="blueGlow.png")]
    private static var blueGlow:Class;
    [Embed(source="orangeGlow.png")]
    private static var orangeGlow:Class;
    [Embed(source="pinkGlow.png")]
    private static var pinkGlow:Class;
    [Embed(source="redGlow.png")]
    private static var redGlow:Class;

    public static function get BLUE_GLOW():BitmapData {
        if (blueGlowBitmap == null) {
            blueGlowBitmap = new blueGlow();
            blueGlowBitmap.smoothing = true;
        }
        return blueGlowBitmap.bitmapData;
    }

    public static function get ORANGE_GLOW():BitmapData {
        if (orangeGlowBitmap == null) {
            orangeGlowBitmap = new orangeGlow();
            orangeGlowBitmap.smoothing = true;
        }
        return orangeGlowBitmap.bitmapData;
    }

    public static function get PINK_GLOW():BitmapData {
        if (pinkGlowBitmap == null) {
            pinkGlowBitmap = new pinkGlow();
            pinkGlowBitmap.smoothing = true;
        }
        return pinkGlowBitmap.bitmapData;
    }

    public static function get RED_GLOW():BitmapData {
        if (redGlowBitmap == null) {
            redGlowBitmap = new redGlow();
            redGlowBitmap.smoothing = true;
        }
        return redGlowBitmap.bitmapData;
    }
}
}