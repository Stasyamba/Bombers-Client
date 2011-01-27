/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.bombers.bots.IWalkingStrategy
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IGameSkills
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombers.skin.BomberSkin
import engine.bombss.BombsBuilder
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.weapons.interfaces.IWeapon

public class PlayersBuilder {

    private var bombsBuilder:BombsBuilder;


    public function makePlayer(game:IGame, playerId:int, name:String, color:PlayerColor, skills:IGameSkills, weapon:IWeapon, skin:BomberSkin):IPlayerBomber {
        var inputDirection:InputDirection = new InputDirection();

        return new PlayerBomber(game, playerId, name, color, inputDirection, skills, weapon, skin, bombsBuilder)
    }

    public function makeEnemy(game:IGame, playerId:int, name:String, color:PlayerColor, skills:IGameSkills, weapon:IWeapon, skin:BomberSkin):IEnemyBomber {
        return new EnemyBomber(game, playerId, name, bombsBuilder, skills, weapon, skin, color);
    }

    public function makeEnemyBot(game:IGame, playerId:int, name:String, color:PlayerColor, skills:IGameSkills, weapon:IWeapon, skin:BomberSkin, walkingStrategy:IWalkingStrategy):IEnemyBomber {
        return new BotEnemyBomber(game, playerId, name, bombsBuilder, skills, weapon, skin, color, walkingStrategy);
    }


    public function PlayersBuilder(bombsBuilder:BombsBuilder) {
        this.bombsBuilder = bombsBuilder;
    }
}
}