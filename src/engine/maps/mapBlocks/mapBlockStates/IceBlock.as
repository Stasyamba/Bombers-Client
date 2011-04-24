/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IActiveMapBlockState
import engine.maps.interfaces.IDynObject
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType
import engine.ui.IceSprite
import engine.utils.ViewState
import engine.weapons.WeaponType

import greensock.TweenMax

public class IceBlock implements IActiveMapBlockState {
    public function IceBlock() {
    }

    public function activateOn(creature:CreatureBase):void {
        var b:IBomber = creature as IBomber
        if (b != null) {
            if (!b.hasAura(WeaponType.ICE_AURA)) {
                freeze(b)
                TweenMax.delayedCall(3, unfreeze, [creature])
            }
        }
    }

    private function unfreeze(bomber:IBomber):void {
        bomber.resetSpeed()
        bomber.stateRemoved.dispatch("freeze")
    }

    private function freeze(bomber:IBomber):void {
        bomber.setSpeed(0)
        var child:IceSprite = new IceSprite()
        child.alpha = 0
        bomber.stateAdded.dispatch(new ViewState("freeze", {}, null, child, TweenMax.to(child, 1, {alpha:1})))
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function canGoThrough():Boolean {
        return true
    }

    public function canSetBomb():Boolean {
        return true
    }

    public function canExplosionGoThrough():Boolean {
        return true
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false
    }

    public function explode(expl:IExplosion):void {
    }

    public function get type():MapBlockType {
        return MapBlockType.ICE
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.ICE
    }

    public function get canShowObjects():Boolean {
        return true
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {
    }
}
}
