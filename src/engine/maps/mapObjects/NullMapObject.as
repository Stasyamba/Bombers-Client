/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.maps.interfaces.IMapObjectType
import engine.maps.mapBlocks.NullMapBlock

public class NullMapObject implements IMapObject {

    private static var instance:NullMapObject;

    public static function getInstance():NullMapObject {
        if (instance == null)
            instance = new NullMapObject();
        return instance;
    }

    function NullMapObject() {
    }

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function canGoThrough():Boolean {
        return true;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function get type():IMapObjectType {
        return MapObjectType.NULL;
    }

    public function activateOn(player:IBomber):void {
    }

    public function tryToTake():void {
    }

    public function get wasTriedToBeTaken():Boolean {
        return false;
    }

    public function get x():int {
        return -1;
    }

    public function get y():int {
        return -1;
    }

    public function get block():IMapBlock {
        return NullMapBlock.getInstance();
    }
}
}