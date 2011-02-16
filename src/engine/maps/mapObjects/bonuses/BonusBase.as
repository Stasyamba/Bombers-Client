/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IMapBlock

public class BonusBase {

    protected var _block:IMapBlock;
    private var _wasTriedToBeTaken:Boolean = false;

    public function BonusBase(block:IMapBlock) {
        this._block = block;
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

    public function get block():IMapBlock {
        return _block;
    }

    public function get x():int {
        return block.x;
    }

    public function get y():int {
        return block.y;
    }

    public function activateOn(player:IBomber):void {
        block.collectObject(Context.game.playerManager.isItMe(player));
    }

    public function tryToTake():void {
        _wasTriedToBeTaken = true;
    }

    public function get wasTriedToBeTaken():Boolean {
        return _wasTriedToBeTaken;
    }

    public function onAddedToMap():void {
    }

    public function get removeAfterActivation():Boolean {
        return true
    }
}
}