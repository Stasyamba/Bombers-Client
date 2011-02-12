/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data.location1.maps {
import engine.utils.Utils

import flash.events.Event
import flash.net.URLLoader
import flash.net.URLRequest

public class Maps {

    private static var uLoader:URLLoader = new URLLoader();

    //singlePlayer

    [Embed(source="testSingle.xml",mimeType="application/octet-stream")]
    private static const testClass:Class;
    [Embed(source="tutorial_1.xml",mimeType="application/octet-stream")]
    private static const tutorial_1Class:Class;


    private static var _test:XML;
    private static var _tutorial_1:XML;

    private static function get test():XML {
        if (_test == null) {
            _test = Utils.getXml(testClass);
        }
        return _test
    }

    private static function get tutorial_1():XML {
        if (_tutorial_1 == null) {
            _tutorial_1 = Utils.getXml(tutorial_1Class);
        }
        return _tutorial_1
    }

    public static var map1:XML;
    public static var map2:XML;

    public static function getXmlById(mapId:String):XML {

        if (Maps[mapId] != null) {
            return Maps[mapId];
        }
        uLoader.load(new URLRequest("http://www.vensella.ru/bombers/maps/map" + mapId + ".xml?" + String(int(1 + Math.random() * 100000))))
        if (!uLoader.hasEventListener(Event.COMPLETE))
            uLoader.addEventListener(Event.COMPLETE, u_completeHandler);
        return null;
    }

    private static function u_completeHandler(event:Event):void {

        var str:String = uLoader.data as String;
        var xml:XML = new XML(str);

        var id:String = xml.id.@val;
        Maps[id] = xml;
        Context.gameModel.mapLoaded.dispatch(xml)
    }
}
}