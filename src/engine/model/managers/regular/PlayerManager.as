/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.data.Consts
import engine.explosionss.ExplosionPoint
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.model.managers.PlayerManagerBase
import engine.model.managers.interfaces.IPlayerManager

public class PlayerManager extends PlayerManagerBase implements IPlayerManager {


    public function PlayerManager() {
    }

    public function checkPlayerMetExplosion(expl:IExplosion):void {
        if (me.isDead)
            return;
        if (me.isImmortal) return;
        var b:IMapBlock = me.coords.getPartBlock();
        var def:Number = me.coords.getPartBlockDef();

        expl.forEachPoint(function(point:ExplosionPoint):void {
            if (me.isImmortal) return;
            if (me.coords.elemX == point.x && me.coords.elemY == point.y)
                me.explode(expl);
            else if (b.x == point.x && b.y == point.y && def > Consts.EXPLOSION_DEFLATION)
                me.explode(expl);
        })
    }

    public function checkPlayerMetDieWall(x:int, y:int):Boolean {
        if (me.isDead)
            return false;
        var b:IMapBlock = me.coords.getPartBlock();
        var def:Number = me.coords.getPartBlockDef();
        if (me.coords.elemX == x && me.coords.elemY == y)
            return true;
        else if (b.x == x && b.y == y && def > Consts.EXPLOSION_DEFLATION)
            return true;
        return false;

    }

    public function checkPlayerMetObject(object:IDynObject):Boolean {
        if (me.isDead)
            return false;
        var b:IMapBlock = me.coords.getPartBlock();
        return (me.coords.elemX == object.x && me.coords.elemY == object.y
                || b.x == object.x && b.y == object.y)
    }

}
}