/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects {
import engine.bombers.interfaces.IBomber
import engine.maps.mapObjects.DynObjectType
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.NullMapBlock

public class NullDynObject implements IDynObject {

    private static var instance:NullDynObject;

    public function onAddedToMap():void {
    }

    public function get removeAfterActivation():Boolean {
        return false
    }

    public static function getInstance():NullDynObject {
        if (instance == null)
            instance = new NullDynObject();
        return instance;
    }

    function NullDynObject() {
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

    public function get type():IDynObjectType {
        return DynObjectType.NULL;
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