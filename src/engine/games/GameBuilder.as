/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import com.smartfoxserver.v2.entities.Room
import com.smartfoxserver.v2.entities.User

import engine.data.location1.games.Games
import engine.games.single.SinglePlayerGame
import engine.games.single.goals.GoalsBuilder
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile

public class GameBuilder {
    public function GameBuilder() {
    }

    private function getColor(playerId:int):PlayerColor {
        switch (playerId) {
            case 4:
                return PlayerColor.BLUE;
            case 3:
                return PlayerColor.ORANGE;
            case 1:
                return PlayerColor.PINK;
            case 2:
                return PlayerColor.RED;

        }
        throw new Error("No more colors")
    }

    public function makeRegular(mapId:int, playerProfiles:Array):IGame {
        var game:RegularGame = new RegularGame();
        for each (var prof:PlayerGameProfile in playerProfiles) {
            game.addPlayer(prof, getColor(prof.playerId))
        }
        game.applyMap(String(mapId), playerProfiles)
        return game;
    }

    public function makeSinglePlayer(gameType:GameType, gameId:String):IGame {
        var xml:XML = Games[gameId];
        switch (gameType) {
            case GameType.SINGLE:
                var game:SinglePlayerGame = new SinglePlayerGame();
                game.addPlayer(Context.gameServer.mySelf, getColor(1))
                for each (var enemy:XML in xml.enemies.Enemy) {
                    game.addBot(getColor(enemy.@id))
                }
                for each (var goal:XML in xml.goals.children()) {
                    game.addGoal(GoalsBuilder.makeFromXml(goal));
                }
                game.applyMap(xml.map.@val)
                return game;
        }
        throw new ArgumentError("invalid gameType");
    }
}
}