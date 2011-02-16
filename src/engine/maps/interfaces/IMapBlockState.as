/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.explosionss.interfaces.IExplosion
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType

public interface IMapBlockState {

    function explodesAndStopsExplosion():Boolean

    function canGoThrough():Boolean;

    function canSetBomb():Boolean;

    function canExplosionGoThrough():Boolean

    function canHaveExplosionPrint(explType:ExplosionType):Boolean;

    function explode(expl:IExplosion):void;

    function get type():MapBlockType;

    function stateAfterExplosion(expl:IExplosion):MapBlockType;

    function get canShowObjects():Boolean;

    function get hiddenObject():IDynObject;

    function set hiddenObject(value:IDynObject):void ;
}
}