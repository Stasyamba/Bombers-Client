/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data.location1.mapObjects {
import engine.maps.bigObjects.BigObjectDescription

import flash.utils.ByteArray
import flash.utils.Dictionary

public class BigObjects {

    private static var _objects:Dictionary;

    public static function get objects():Dictionary {
        if (_objects == null) {
            _objects = new Dictionary();

            var file:ByteArray = new VK_CLASS();
            var str:String = file.readUTFBytes(file.length);
            var xml:XML = new XML(str);
            _objects[VK_ID] = new BigObjectDescription(xml);
        }
        return _objects;
    }

    [Embed(source="vk.xml",mimeType="application/octet-stream")]
    private static const VK_CLASS:Class;
    private static const VK_ID:String = "vk";


}
}