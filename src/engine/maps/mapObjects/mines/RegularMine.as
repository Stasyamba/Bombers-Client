/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.mines {
import engine.bombers.interfaces.IBomber
import engine.explosionss.Explosion
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObjectType

public class RegularMine implements IMine {

    private var _block:IMapBlock
    private var _wasTriedToBeTaken:Boolean = false;

    public function RegularMine(block:IMapBlock) {
        _block = block
    }

    public function canExplosionGoThrough():Boolean {
        return true
    }

    public function canGoThrough():Boolean {
        return true
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function get x():int {
        return _block.x;
    }

    public function get y():int {
        return _block.y;
    }

    public function get block():IMapBlock {
        return _block
    }

    public function get type():IMapObjectType {
        return MineType.REGULAR;
    }

    public function activateOn(bomber:IBomber):void {
        if (!bomber.isImmortal)
            bomber.explode(new Explosion(null, -1, -1, 1))
    }

    public function tryToTake():void {
        _wasTriedToBeTaken = true;
    }

    public function get wasTriedToBeTaken():Boolean {
        return _wasTriedToBeTaken;
    }
}
}
