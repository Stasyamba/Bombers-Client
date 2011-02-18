/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks {
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

import org.osflash.signals.Signal

/*
* NullMapBlock is to avoid null checks
* */
public class NullMapBlock extends MapBlockBase implements IMapBlock {


    private static var instance:NullMapBlock;

    public static function getInstance():NullMapBlock {
        if (instance == null)
            instance = new NullMapBlock();
        return instance;
    }

    public function stopExplosion():void {
    }

    public function setState(state:IMapBlockState):void {
    }

    public function get destroyed():Signal {
        return null;
    }

    public function get objectCollected():Signal {
        return null;
    }


    public override function get x():int {
        return -1;
    }

    public override function get y():int {
        return -1;
    }

    public function get isExplodingNow():Boolean {
        return false;
    }

    public function get explodedBy():ExplosionType {
        return ExplosionType.NULL;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false;
    }

    public function collectObject(byMe:Boolean):void {
    }

    public override function get state():IMapBlockState {
        return null;
    }

    public function get hasExplosionPrint():Boolean {
        return false;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function canSetBomb():Boolean {
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        return false;
    }

    public function explode(expl:IExplosion):void {
    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        return MapBlockType.NULL;
    }

    public function get object():IDynObject {
        return NullDynObject.getInstance();
    }

    public override function get type():MapBlockType {
        return MapBlockType.NULL;
    }

    public function NullMapBlock() {
    }

    public function setObject(object:IDynObject):void {
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function set hiddenObject(value:IDynObject):void {
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function setDieWall():void {
        trace("SHIIIIIT");
    }

    public function get objectSet():Signal {
        return null
    }
}
}