/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.singlePlayer {
import engine.bombers.interfaces.IEnemyBomber
import engine.data.Consts
import engine.explosionss.ExplosionPoint
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.model.managers.EnemiesManagerBase
import engine.model.managers.interfaces.IEnemiesManager

public class SinglePlayerEnemiesManager extends EnemiesManagerBase implements IEnemiesManager {

    public function SinglePlayerEnemiesManager() {
    }

    public function checkEnemiesMetExplosion(e:IExplosion):void {
        forEachAliveEnemy(function todo(enemy:IEnemyBomber, id:int):void {
            if (enemy.isDead)
                return;
            if (enemy.isImmortal) return;
            var b:IMapBlock = enemy.coords.getPartBlock();
            var def:Number = enemy.coords.getPartBlockDef();

            e.forEachPoint(function(point:ExplosionPoint):void {
                if (enemy.isImmortal) return;
                if (enemy.coords.elemX == point.x && enemy.coords.elemY == point.y)
                    enemy.explode(e);
                else if (b.x == point.x && b.y == point.y && def > Consts.EXPLOSION_DEFLATION)
                    enemy.explode(e);
            })
        })

    }

    public function checkEnemyTakenObject(enemy:IEnemyBomber, object:IMapObject):Boolean {
        var b:IMapBlock = enemy.coords.getPartBlock();
        return (enemy.coords.elemX == object.x && enemy.coords.elemY == object.y
                || b.x == object.x && b.y == object.y)


    }
}
}