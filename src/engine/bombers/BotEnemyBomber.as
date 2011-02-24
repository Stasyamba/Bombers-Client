/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.bots.IWalkingStrategy
import engine.bombers.interfaces.IEnemyBomber
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction

public class BotEnemyBomber extends EnemyBomber implements IEnemyBomber {

    private var walkingStrategy:IWalkingStrategy;

    public function BotEnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, color:PlayerColor, walkingStrategy:IWalkingStrategy) {
        super(game, playerProfile, userName, color)

        this.walkingStrategy = walkingStrategy;
    }

    public override function move(elapsedMilliSecs:int):void {
        var willCover:Number = elapsedMilliSecs * speed / 1000;
        if (willGetToBlockCenter(willCover)) {
            var d:Direction = walkingStrategy.getDirection(_direction, _coords);
            if (d != _direction)
                EngineContext.enemyInputDirectionChanged.dispatch(slot, _coords.getRealX(), _coords.getRealY(), d);
        }
        super.move(elapsedMilliSecs);
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

    override public function explode(expl:IExplosion):void {
        super.explode(expl);
        EngineContext.enemyDamaged.dispatch(slot, _life - expl.damage >= 0 ? _life - expl.damage : 0)
        if (isDead) {
            EngineContext.enemyDied.dispatch(slot);
        }
    }
}
}