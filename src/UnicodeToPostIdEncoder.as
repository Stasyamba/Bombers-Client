/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package {
public class UnicodeToPostIdEncoder {

    public static function encodeSymbol(s:uint):String {
        if (s <= 0xF)
            return "y" + s.toString(16)
        if (s <= 0xFF)
            return "x" + s.toString(16)
        var res:String = s.toString(16)
        if (res.length == 3)
            return "0" + res
        return res
    }

    public static function encodeString(str:String):String {
        var res:String = ""
        for (var i:int = 0; i < str.length; i++) {
            var s:int = str.charCodeAt(i);
            res = appendSymbol(res, s)
        }
        return res
    }

    public static function appendSymbol(to:String, s:uint):String {
        return to + encodeSymbol(s)
    }

    public static function appendString(to:String, str:String):String {
        return to + encodeString(str)
    }

    public static function appendDelimeter(str:String):String {
        return str + "o"
    }

    public static function encodeStringArray(arr:Array):String {
        var res:String = ""
        for (var i:int = 0; i < arr.length; i++) {
            var string:String = arr[i];
            if (string == null)
                throw new ArgumentError("Array \"arr\" must contain only non-null strings")
            if (i < arr.length - 1)
                res = appendDelimeter(appendString(res, string))
            else
                res = appendString(res, string)
        }
        return res
    }

    //decode

    public static function decodeSymbol(s:String):uint {
        var i:int = 0
        if (s.charAt(0) == "x" || s.charAt(0) == "y")
            i++;
        var hex:String = "0x" + s.substr(i)
        return uint(hex)
    }

    private static function getNextSymbol(s:String):String {
        switch (s.charAt(0)) {
            case "y":
                return s.substr(0, 2)
            case "x":
                return s.substr(0, 3)
        }
        return s.substr(0, 4)
    }

    public static function decodeString(s:String):String {
        var copy:String = s.substr()
        var res:String = ""
        while(copy.length > 0) {
            var sym:String = getNextSymbol(copy)
            var code:int = decodeSymbol(sym)
            res += String.fromCharCode(code)
            copy = copy.substr(sym.length)
        }
		return res
    }

    public static function decodeStringArray(s:String):Array{
        var strings:Array = s.split("o")
        var result:Array = new Array()
        for (var i:int = 0; i < strings.length; i++) {
            var string:String = strings[i];
            result.push(UnicodeToPostIdEncoder.decodeString(string))
        }
        return result
    }

    public function UnicodeToPostIdEncoder() {
    }
}
}
