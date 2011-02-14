/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.skin.BomberSkin
import engine.bombss.BombsBuilder
import engine.data.Consts
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction

public class EnemyBomber extends BomberBase implements IEnemyBomber {

    protected var _direction:Direction = Direction.NONE;


    public function EnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, bombBuilder:BombsBuilder, color:PlayerColor) {
        super(game, playerProfile.playerId, userName, color, BomberSkin.fromBomberType(playerProfile.bomberType), bombBuilder);

        EngineContext.enemyInputDirectionChanged.add(directionChanged);
        EngineContext.enemyDamaged.add(onDamaged);
        EngineContext.enemyDied.add(onDied);
    }

    private function onDied(id:int):void {
        if (id == playerId)
            kill();
    }

    protected function onDamaged(id:int, health_left:int):void {
        if (playerId == id) {
            _life = health_left;
            makeImmortalFor(immortalTime);
        }
    }

    protected function directionChanged(id:int, x:Number, y:Number, dir:Direction):void {
        if (id != playerId)
            return;

        _coords.elemX = int(x / Consts.BLOCK_SIZE);
        _coords.xDef = x % Consts.BLOCK_SIZE;

        _coords.elemY = int(y / Consts.BLOCK_SIZE);
        _coords.yDef = y % Consts.BLOCK_SIZE;

        _gameSkin.updateSkin(dir);
        _direction = dir;
    }

    public function performSmoothMotion(moveAmount:Number):void {
        switch (_direction) {
            case Direction.NONE:
                return;
            case Direction.LEFT:
                _coords.stepLeft(moveAmount);
                break;
            case Direction.RIGHT:
                _coords.stepRight(moveAmount);
                break;
            case Direction.UP:
                _coords.stepUp(moveAmount);
                break;
            case Direction.DOWN:
                _coords.stepDown(moveAmount);
                break;
        }
        EngineContext.enemySmoothMovePerformed.dispatch(playerId, _coords.getRealX(), _coords.getRealY());
    }

    public override function move(elapsedTime:Number):void {
        performSmoothMotion(elapsedTime * speed);
    }

    public override function kill():void {
        _life = 0;
    }

    public override function explode(expl:IExplosion):void {
    }


}
}