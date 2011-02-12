/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.bots.IWalkingStrategy
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.skin.BomberSkin
import engine.bombss.BombsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction
import engine.weapons.interfaces.IWeapon

public class BotEnemyBomber extends EnemyBomber implements IEnemyBomber {

    private var walkingStrategy:IWalkingStrategy;

    public function BotEnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, bombBuilder:BombsBuilder, color:PlayerColor, walkingStrategy:IWalkingStrategy) {
        super(game, playerProfile, userName, bombBuilder, color)

        this.walkingStrategy = walkingStrategy;
    }

    public override function move(elapsedTime:Number):void {
        var willCover:Number = elapsedTime * speed;
        if (willGetToBlockCenter(willCover)) {
            var d:Direction = walkingStrategy.getDirection(_direction, _coords);
            if (d != _direction)
                EngineContext.enemyInputDirectionChanged.dispatch(playerId, _coords.getRealX(), _coords.getRealY(), d);
        }
        super.move(elapsedTime);
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
        EngineContext.enemyDamaged.dispatch(playerId, _life - expl.damage >= 0 ? _life - expl.damage : 0)
        if (isDead) {
            EngineContext.enemyDied.dispatch(playerId);
        }
    }
}
}