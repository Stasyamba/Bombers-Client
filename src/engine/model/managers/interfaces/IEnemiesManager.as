package engine.model.managers.interfaces {
import engine.bombers.interfaces.IEnemyBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject

public interface IEnemiesManager {
    /*
     * Function must look like this:
     * function do(item:IEnemyBomber, playerId:int):void;
     * */
    function forEachAliveEnemy(todo:Function):void;

    function moveEnemies(elapsedMiliSecs:int):void;

    function addEnemy(enemy:IEnemyBomber):void;

    function getEnemyById(playerId:int):IEnemyBomber;

    function hasEnemy(playerId:int):Boolean;

    function get enemiesCount():int;

    function checkEnemiesMetExplosion(e:IExplosion):void;

    function checkEnemyTakenObject(enemie:IEnemyBomber, object:IDynObject):Boolean
}
}