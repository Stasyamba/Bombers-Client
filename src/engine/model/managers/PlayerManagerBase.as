/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers {
import engine.bombers.interfaces.IPlayerBomber
import engine.data.Consts
import engine.explosionss.ExplosionPoint
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject

public class PlayerManagerBase {
    public function PlayerManagerBase() {
    }

    protected var _me:IPlayerBomber;

    public function setPlayer(player:IPlayerBomber):void {
        _me = player;
    }

    public function movePlayer(elapsedMiliSecs:int):void {
        if (me.isDead)
            return;
        var elapsedSecs:Number = elapsedMiliSecs / 1000;
        me.move(elapsedSecs);
    }

    //todo: later maybe let explosion manager explode players, here just return bool
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

    public function get me():IPlayerBomber {
        return _me;
    }

    public function get myId():int {
        return _me.playerId;
    }

    public function checkPlayerMetObject(object:IMapObject):Boolean {
        if (me.isDead)
            return false;
        var b:IMapBlock = me.coords.getPartBlock();
        return (me.coords.elemX == object.x && me.coords.elemY == object.y
                || b.x == object.x && b.y == object.y)
        //{
//            if (!object.wasTriedToBeTaken) {
//                me.tryTakeObject(object);
//                return true;
//            }
//    }
//        return false;
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

    public function killMe():void {
        me.kill();
    }
}
}