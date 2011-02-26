/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.skin.BomberSkin
import engine.data.Consts
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction

public class EnemyBomber extends BomberBase implements IEnemyBomber {

    protected var _direction:Direction = Direction.NONE;


    public function EnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, color:PlayerColor) {
        super(game, playerProfile.slot, playerProfile.bomberType, userName, color, BomberSkin.fromBomberType(playerProfile.bomberType));

        for (var i:int = 0; i < playerProfile.auras.length; i++) {
            var object:Object = playerProfile.auras[i];

        }

        EngineContext.enemyInputDirectionChanged.add(directionChanged);
        EngineContext.enemyDamaged.add(onDamaged);
        EngineContext.enemyDied.add(onDied);
    }

    private function onDied(id:int):void {
        if (id == slot)
            kill();
    }

    protected function onDamaged(id:int, health_left:int):void {
        if (slot == id) {
            life = health_left;
            makeImmortalFor(immortalTime);
        }
    }

    protected function directionChanged(id:int, x:Number, y:Number, dir:Direction):void {
        if (id != slot)
            return;
        if(!Context.gameModel.isPlayingNow)
            return
        _coords.elemX = int(x / Consts.BLOCK_SIZE);
        _coords.xDef = x % Consts.BLOCK_SIZE;

        _coords.elemY = int(y / Consts.BLOCK_SIZE);
        _coords.yDef = y % Consts.BLOCK_SIZE;

        _gameSkin.updateSkin(dir);
        _direction = dir;
    }

    public function performSmoothMotion(moveAmount:Number):void {
        if (!Context.gameModel.isPlayingNow)
            return
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
        EngineContext.enemySmoothMovePerformed.dispatch(slot, _coords.getRealX(), _coords.getRealY());
    }

    public override function move(elapsedMilliSecs:int):void {
        performSmoothMotion(elapsedMilliSecs * speed / 1000);
    }

    public override function kill():void {
        life = 0;
    }

    public override function explode(expl:IExplosion):void {
    }


}
}