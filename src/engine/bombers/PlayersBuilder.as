/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.bombers.bots.IWalkingStrategy
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.profiles.LobbyProfile
import engine.profiles.PlayerGameProfile
import engine.weapons.WeaponBuilder

public class PlayersBuilder {

    private var weaponBuilder:WeaponBuilder

    public function makePlayer(game:IGame, gameProfile:GameProfile, playerProfile:PlayerGameProfile, color:PlayerColor):IPlayerBomber {
        var inputDirection:InputDirection = new InputDirection();

        return new PlayerBomber(game, playerProfile.playerId, gameProfile, color, inputDirection, weaponBuilder)
    }

    public function makeEnemy(game:IGame, lobbyProfile:LobbyProfile, playerProfile:PlayerGameProfile, color:PlayerColor):IEnemyBomber {
        return new EnemyBomber(game, playerProfile, lobbyProfile.nick, color);
    }

    public function makeEnemyBot(game:IGame, playerProfile:PlayerGameProfile, name:String, color:PlayerColor, walkingStrategy:IWalkingStrategy):IEnemyBomber {
        return new BotEnemyBomber(game, playerProfile, name, color, walkingStrategy);
    }


    public function PlayersBuilder(weaponBuilder:WeaponBuilder) {
        this.weaponBuilder = weaponBuilder;
    }
}
}