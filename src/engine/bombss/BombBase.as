/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.weapons.WeaponType

public class BombBase {


    public function BombBase(explosionsBuilder:ExplosionsBuilder, block:IMapBlock, owner:IBomber) {
        _block = block;
        _owner = owner;
        _explosionsBuilder = explosionsBuilder;
    }

    protected var _explodeTime:int;
    protected var _block:IMapBlock;
    protected var _owner:IBomber;
    protected var _explosionsBuilder:ExplosionsBuilder;

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function onTimeElapsed(elapsedMilliSecs:int):void {
        _explodeTime -= elapsedMilliSecs;
    }

    public function get timeToActivate():int {
        return _explodeTime;
    }

    public function get owner():IBomber {
        return _owner;
    }

    public function get block():IMapBlock {
        return _block;
    }

    public function get x():int {
        return _block.x
    }

    public function get y():int {
        return _block.y
    }

    public function get removeAfterActivation():Boolean {
        return true
    }

    public function grabCorrespondingWeapon():void {
        if (Context.game.playerManager.isItMe(_owner))
            Context.game.playerManager.me.decWeapon(WeaponType.byValue(type.value))
    }

    public function activateOn(player:IBomber):void {
        var expl:IExplosion = getExplosion()
        expl.perform();
        Context.game.explosionExchangeBuffer.push(expl)

        block.collectObject(false)
        _owner.returnBomb();
    }

    public function get type():IDynObjectType {
        throw new Error("abstract method call")
    }

    protected function getExplosion():IExplosion {
        throw new Error("abstract method call")
    }

    public function addVictim(player:IBomber):void {
    }

    public function get victim():IBomber {
        return null
    }
}
}