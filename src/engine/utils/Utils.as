/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.utils {
import engine.explosionss.Explosion

import flash.display.Bitmap
import flash.ui.Keyboard
import flash.utils.ByteArray
import flash.utils.getDefinitionByName
import flash.utils.getQualifiedClassName

import mx.utils.ObjectUtil

public class Utils {

    private static const allowedForName:String = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_����������������������������������������������������������������ި-1234567890"

    public static function getClass(value:*):Class {
        return getDefinitionByName(getQualifiedClassName(value)) as Class;
    }

    public static function checkNick(nick:String):Boolean {
        return nick.length > 4 && !(nick.length > 12)
    }
    public static function isArrowKey(code:uint):Boolean {
        return code == Keyboard.LEFT || code == Keyboard.RIGHT || code == Keyboard.UP || code == Keyboard.DOWN;
    }

    public static function arrowKeyCodeToDirection(code:uint):Direction {
        switch (code) {
            case Keyboard.LEFT:
                return Direction.LEFT;
            case Keyboard.RIGHT:
                return Direction.RIGHT;
            case Keyboard.UP:
                return Direction.UP;
            case Keyboard.DOWN:
                return Direction.DOWN;
        }
        throw new ArgumentError("Argument Code is not a valid keyboard arrow code");
    }

    public static function between(x1:Number, arg:Number, x2:Number):Boolean {
        if (x2 < x1) {
            throw ArgumentError("x1 must be less or equal than x2");
        }
        return arg <= x2 && arg >= x1;
    }

    public static function isCorrectGameName(name:String):Boolean {
        return name.length >= 3;
    }

    public static function getXml(c:Class):XML {
        var file:ByteArray = new c();
        var str:String = file.readUTFBytes(file.length);
        return new XML(str);
    }
}
}