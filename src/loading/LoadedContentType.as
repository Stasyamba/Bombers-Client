/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
public class LoadedContentType {

    public static var IMAGE:LoadedContentType = new LoadedContentType(0)
    public static var SWF:LoadedContentType = new LoadedContentType(1)
    public static var VIDEO:LoadedContentType = new LoadedContentType(2)
    public static var MP3:LoadedContentType = new LoadedContentType(3)

    private var _value:int

    public function LoadedContentType(value:int) {
        _value = value
    }
}
}
