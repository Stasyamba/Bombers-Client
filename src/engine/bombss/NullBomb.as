/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.maps.mapBlocks.NullMapBlock

public class NullBomb implements ITimeActivatableDynObject {

    private static var instance:NullBomb;

    public static function getInstance():NullBomb {
        if (instance == null)
            instance = new NullBomb();
        return instance;
    }

    public function get timeToActivate():int {
        return 0
    }

    public function addVictim(player:IBomber):void {
    }

    public function get victim():IBomber {
        return null
    }

    public function get x():int {
        return 0
    }

    public function get y():int {
        return 0
    }

    public function activateOn(player:IBomber):void {
    }

    public function onAddedToMap():void {
    }

    public function get owner():IBomber {
        return null
    }

    public function get removeAfterActivation():Boolean {
        return true
    }

    function NullBomb() {
    }

    public function onTimeElapsed(elapsedMilliSecs:int):void {
    }

    public function get block():IMapBlock {
        trace("SHIT, null bomb block requested")
        return NullMapBlock.getInstance();
    }

    public function get type():IDynObjectType {
        return BombType.NULL;
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
}
}