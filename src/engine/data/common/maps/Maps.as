/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data.common.maps {
import flash.events.Event
import flash.net.URLLoader
import flash.net.URLRequest

public class Maps {

    private static var uLoader:URLLoader = new URLLoader();

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