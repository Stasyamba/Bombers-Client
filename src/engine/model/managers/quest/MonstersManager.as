/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.bombers.interfaces.IPlayerBomber
import engine.data.Consts
import engine.explosionss.ExplosionPoint
import engine.explosionss.interfaces.IExplosion
import engine.games.quest.monsters.Monster
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.model.managers.interfaces.IPlayerManager

public class MonstersManager {

    protected var _monsters:Array = new Array();
    private var _count:int = 0;

    private var _playerManager:IPlayerManager

    public function MonstersManager(playerManager:IPlayerManager) {
        _playerManager = playerManager
    }

    public function addMonster(monster:Monster):void {
        _monsters[monster.slot] = monster;
        _count++;
    }

    public function removeMonsterBySlot(slot:int):void {
        _monsters[slot] = null;
        _count--;
    }

    public function getMonsterBySlot(slot:int):Monster {
        return _monsters[slot];
    }

    public function get count():int {
        return _count;
    }

    public function hasMonster(slot:int):Boolean {
        return !(_monsters[slot] == null);
    }


    public function forEachAliveMonster(todo:Function):void {
        for (var i:int = 0; i < _monsters.length; i++) {
            var monster:Monster = _monsters[i];
            if (monster != null && !monster.isDead)
                todo(monster, i);
        }
    }

    public function moveMonsters(elapsedMilliSecs:int):void {
        forEachAliveMonster(function (monster:Monster, slot:int):void {
            monster.move(elapsedMilliSecs);
        })
    }

    public function checkMonstersMetExplosion(e:IExplosion):void {
        forEachAliveMonster(function todo(monster:Monster, id:int):void {
            if (monster.isDead)
                return;
            if (monster.isImmortal) return;
            var b:IMapBlock = monster.coords.getPartBlock();
            var def:Number = monster.coords.getPartBlockDef();

            e.forEachPoint(function(point:ExplosionPoint):void {
                if (monster.isImmortal) return;
                if (monster.coords.elemX == point.x && monster.coords.elemY == point.y)
                    monster.explode(e);
                else if (b.x == point.x && b.y == point.y && def > Consts.EXPLOSION_DEFLATION)
                    monster.explode(e);
            })
        })
    }

    public function checkMonsterTakenObject(monster:Monster, object:IDynObject):Boolean {
        var b:IMapBlock = monster.coords.getPartBlock();
        return (monster.coords.elemX == object.x && monster.coords.elemY == object.y
                || b.x == object.x && b.y == object.y)
    }

    public function checkMonstersHitPlayer(elapsedMilliSecs:int):void {
        var me:IPlayerBomber = _playerManager.me
        if (me.isDead)
            return;
        if (me.isImmortal) return;
        var x:Number = me.coords.getRealX()
        var y:Number = me.coords.getRealY()

        forEachAliveMonster(function(monster:Monster,slot:int):void {
            if (me.isImmortal) return;
            if (monster.monsterType.damage <= 0) return
            if ((me.coords.elemY == monster.coords.elemY && Math.abs(x - monster.coords.getRealX()) < Consts.BOMBER_SIZE) ||
                    (me.coords.elemX == monster.coords.elemX && Math.abs(y - monster.coords.getRealY()) < Consts.BOMBER_SIZE)){
               me.hit(monster.monsterType.damage)
            }
        })
    }

    public function getNewSlot():int {
        return count + 2
    }

}
}