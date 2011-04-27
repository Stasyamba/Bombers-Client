/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.games.IGame
import engine.games.quest.QuestGame
import engine.games.quest.monsters.Monster
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.IWalkingStrategy
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.profiles.LobbyProfile
import engine.profiles.PlayerGameProfile
import engine.weapons.WeaponBuilder

public class PlayersBuilder {

    private var weaponBuilder:WeaponBuilder

    public function makePlayer(game:IGame, gameProfile:GameProfile, playerProfile:PlayerGameProfile, color:PlayerColor):IPlayerBomber {
        var inputDirection:InputDirection = new InputDirection();

        return new PlayerBomber(game, playerProfile.slot, gameProfile, color, inputDirection, weaponBuilder)
    }

    public function makeEnemy(game:IGame, lobbyProfile:LobbyProfile, playerProfile:PlayerGameProfile, color:PlayerColor):IEnemyBomber {
        return new EnemyBomber(game, playerProfile, lobbyProfile.nick, color);
    }

    public function makeMonster(game:IGame, x:int, y:int, slot:int, monsterType:MonsterType, walkingStrategy:IWalkingStrategy):Monster {
        return new Monster(game, x, y, slot, monsterType, walkingStrategy);
    }


    public function PlayersBuilder(weaponBuilder:WeaponBuilder) {
        this.weaponBuilder = weaponBuilder;
    }

    public function makeQuestPlayer(game:QuestGame, gp:GameProfile, playerGameProfile:PlayerGameProfile, color:PlayerColor):QuestPlayerBomber {
        var inputDirection:InputDirection = new InputDirection();

        return new QuestPlayerBomber(game, playerGameProfile.slot, gp, color, inputDirection, weaponBuilder)

    }
}
}