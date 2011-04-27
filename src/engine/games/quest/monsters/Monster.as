/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.quest.monsters {
import engine.EngineContext
import engine.bombers.*
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.games.quest.monsters.walking.IWalkingStrategy
import engine.utils.Direction

public class Monster extends CreatureBase {

    private var _direction:Direction = Direction.NONE
    private var _walkingStrategy:IWalkingStrategy;

    private var _startX:int
    private var _startY:int

    public function Monster(game:IGame, startX:int, startY:int, slot:int, monsterType:MonsterType, walkingStrategy:IWalkingStrategy) {
        super(game, slot, monsterType)
        _walkingStrategy = walkingStrategy;
        _startX = startX
        _startY = startY
        _direction = Direction.NONE
    }

    public function move(elapsedMilliSecs:int):void {
        var willCover:Number = elapsedMilliSecs * speed / 1000;
        if (willGetToBlockCenter(willCover)) {
            var d:Direction = _walkingStrategy.getDirection(_direction, _coords);
            if (d != _direction)
                EngineContext.monsterDirectionChanged.dispatch(slot, _coords.getRealX(), _coords.getRealY(), d);
        }
        performMotion(elapsedMilliSecs * speed / 1000);
    }

    private function willGetToBlockCenter(willCover:Number):Boolean {
        switch (_direction) {
            case Direction.LEFT:
                return (coords.xDef > 0 && Math.abs(coords.xDef) < willCover)
            case Direction.RIGHT:
                return (coords.xDef < 0 && Math.abs(coords.xDef) < willCover)
            case Direction.UP:
                return (coords.yDef > 0 && Math.abs(coords.yDef) < willCover)
            case Direction.DOWN:
                return (coords.yDef < 0 && Math.abs(coords.yDef) < willCover)
        }
        return true;
    }

    public function explode(expl:IExplosion):void {
        EngineContext.enemyDamaged.dispatch(slot, _life - expl.damage >= 0 ? _life - expl.damage : 0)
        if (isDead) {
            EngineContext.enemyDied.dispatch(slot);
        }
    }

    public function performMotion(moveAmount:Number):void {
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
        EngineContext.monsterCoordsChanged.dispatch(slot, _coords.getRealX(), _coords.getRealY());
    }


    public function get startX():int {
        return _startX
    }

    public function get startY():int {
        return _startY
    }

    public override function get direction():Direction {
        return _direction
    }
}
}