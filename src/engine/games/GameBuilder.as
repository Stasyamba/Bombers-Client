/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import components.common.worlds.locations.LocationType

import engine.data.quests.Quests
import engine.games.quest.QuestGame
import engine.games.quest.QuestObject
import engine.games.quest.goals.IGoal
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.WalkingStrategy
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

    public function makeRegular(mapId:int, location:LocationType, playerProfiles:Array):IGame {
        var game:RegularGame = new RegularGame(location);
        for each (var prof:PlayerGameProfile in playerProfiles) {
            game.addPlayer(prof, getColor(prof.slot))
        }
        game.applyMap(String(mapId), playerProfiles)
        return game;
    }

    public function makeQuest(quest:QuestObject, gameId:String):IGame {
        var xml:XML = Quests.questXml(quest.id)
        var game:QuestGame = new QuestGame(gameId, quest);
        //todo:deal with colors
        var plSpawn:XML = xml.map.Map.spawns.Spawn[0]
        game.addPlayer(plSpawn.x, plSpawn.y, getColor(1))
        for each (var m:XML in xml.monsters.Monster) {
            game.addMonster(m.@x, m.@y, MonsterType.byId(m.@monsterId), m.@slot != null ? m.@slot : -1, WalkingStrategy.byId(m.@walks))
        }

        game.applyMapXml(xml.map.Map[0])

        for each (var goal:IGoal in quest.goals) {
            game.addGoal(goal);
        }

        return game;
    }
}
}