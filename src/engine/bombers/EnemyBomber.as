/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction

public class EnemyBomber extends BomberBase implements IEnemyBomber {

    protected var _serverDir:Direction = Direction.NONE;


    public function EnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, color:PlayerColor) {
        super(game, playerProfile.slot, playerProfile.bomberType, userName, color, Context.imageService.bomberSkin(playerProfile.bomberType), playerProfile.auras);

        EngineContext.moveTick.add(onMoveTick)
        EngineContext.enemyDamaged.add(onDamaged);
        EngineContext.enemyDied.add(onDied);
    }

    private function onMoveTick(obj:Object):void {
        if (!Context.gameModel.isPlayingNow)
            return
        var tickObject:Object = obj[slot]
        _coords.setXExplicit(tickObject.x)
        _coords.setYExplicit(tickObject.y)
        if (_serverDir != tickObject.dir) {
            _serverDir = tickObject.dir
            _gameSkin.updateSkin(_serverDir);
            EngineContext.enemyInputDirectionChanged.dispatch(slot, coords.getRealX(), coords.getRealY(), _serverDir)
        }
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

    public function performSmoothMotion(moveAmount:Number):void {
        if (!Context.gameModel.isPlayingNow)
            return
        switch (_serverDir) {
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