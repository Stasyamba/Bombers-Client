/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.monsters.walking {
import engine.EngineContext
import engine.bombers.interfaces.IMapCoords
import engine.utils.Direction

public class RandomDirectionWS implements IWalkingStrategy {

    private var _maxSec:Number

    private var _elapsed:Number
    private var _changeWhenElapsed:Number

    private var _direction:Direction

    public function RandomDirectionWS(maxSec:Number) {
        _maxSec = maxSec
        changeDirection()
        EngineContext.frameEntered.add(onEnterFrame)
    }

    private function nextDuration():Number {
        return 1 + Math.random() * (_maxSec - 1)
    }

    private function onEnterFrame(elapsedMilliSecs:int):void {
        _elapsed += elapsedMilliSecs / 1000
    }

    public function getDirection(dir:Direction, _coords:IMapCoords):Direction {
        if (_elapsed >= _changeWhenElapsed) {
            changeDirection()
        }
        return _direction
    }

    private function changeDirection():void {
        _elapsed = 0
        _direction = Direction.random()
        _changeWhenElapsed = nextDuration()
    }
}
}
