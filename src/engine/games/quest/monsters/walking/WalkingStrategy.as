/*
 * Copyright (c) 2011. 
 * Pavkin Vladimir
 */

package engine.games.quest.monsters.walking {
public class WalkingStrategy {
    public function WalkingStrategy() {
    }

    public static function byId(id:String):IWalkingStrategy {
        switch (id) {
            case "right_wall":
                return new AlongRightWallWalkingStrategy()

        }
        throw new Error("no walking strategy with id = " + id)
    }
}
}
