/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.mines {
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.explosionss.RegularExplosion
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.weapons.WeaponType

public class RegularMine implements ICollectableDynObject {

    private var _block:IMapBlock
    private var _owner:IBomber

    private var _wasTriedToBeTaken:Boolean = false;

    public function RegularMine(block:IMapBlock, owner:IBomber) {
        _block = block
        _owner = owner
    }

    public function onAddedToMap():void {
        if (_owner is IPlayerBomber)
            Context.game.playerManager.me.decWeapon(WeaponType.byValue(type.value))
    }

    public function get removeAfterActivation():Boolean {
        return true
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

    public function get type():IDynObjectType {
        return MineType.REGULAR;
    }

    public function activateOn(bomber:IBomber):void {
        if (!bomber.isImmortal)
            bomber.explode(new RegularExplosion(null, null, -1, -1, 1))
        block.collectObject(Context.game.playerManager.isItMe(bomber))
    }

    public function tryToTake():void {
        _wasTriedToBeTaken = true;
    }

    public function get wasTriedToBeTaken():Boolean {
        return _wasTriedToBeTaken;
    }
}
}
