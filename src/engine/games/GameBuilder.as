/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import components.common.worlds.locations.LocationType

import engine.data.quests.Quests
import engine.games.quest.QuestGame
import engine.games.quest.goals.GoalsBuilder
import engine.games.regular.RegularGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile

public class GameBuilder {
    public function GameBuilder() {
    }

    private function getColor(slot:int):PlayerColor {
        switch (slot) {
            case 3:
                return PlayerColor.BLUE;
            case 2:
                return PlayerColor.ORANGE;
            case 1:
                return PlayerColor.PINK;
            case 0:
                return PlayerColor.RED;

        }
        throw new Error("No more colors")
    }

    public function makeRegular(mapId:int,location:LocationType, playerProfiles:Array):IGame {
        var game:RegularGame = new RegularGame(location);
        for each (var prof:PlayerGameProfile in playerProfiles) {
            game.addPlayer(prof, getColor(prof.slot))
        }
        game.applyMap(String(mapId), playerProfiles)
        return game;
    }

    public function makeQuest(gameType:GameType, location:LocationType, questId:String,gameId:String):IGame {
        var xml:XML = Quests.questXml(questId)
        switch (gameType) {
            case GameType.QUEST:
                var game:QuestGame = new QuestGame(gameId,location);
                //todo:deal with colors
                game.addPlayer(Context.gameServer.mySelf, getColor(1))
                for each (var enemy:XML in xml.enemies.Enemy) {
                    game.addBot()
                }
                for each (var goal:XML in xml.goals.children()) {
                    game.addGoal(GoalsBuilder.makeFromXml(goal));
                }
                game.applyMapXml(xml.map)
                return game;
        }
        throw new ArgumentError("invalid gameType");
    }
}
}