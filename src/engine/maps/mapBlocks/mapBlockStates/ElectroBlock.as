/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IPlayerBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IActiveMapBlockState
import engine.maps.interfaces.IDynObject
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType
import engine.weapons.WeaponType

public class ElectroBlock implements IActiveMapBlockState {

    private var _isHorizontal:Boolean

    public function ElectroBlock(isHorizontal:Boolean) {
        _isHorizontal = isHorizontal
    }

    public function activateOn(creature:CreatureBase):void {

    }

    public function deactivateOn(bomber:CreatureBase):void {
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function canGoThrough(creature:CreatureBase = null):Boolean {
        var b:IPlayerBomber = creature as IPlayerBomber
        if (b != null) {
            return b.hasAura(WeaponType.ELECTRO_AURA)
        }
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
        return _isHorizontal ? MapBlockType.ELECTRO_HOR : MapBlockType.ELECTRO_VERT
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return type
    }

    public function get canShowObjects():Boolean {
        return true
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {
    }

    public function get blinks():Boolean {
        return false
    }

}
}
