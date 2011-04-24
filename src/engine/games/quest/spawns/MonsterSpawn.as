/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.spawns {
import engine.EngineContext
import engine.games.quest.monsters.MonsterType

import flash.events.TimerEvent
import flash.utils.Timer

import greensock.TweenMax

public class MonsterSpawn {

    private var _x:int
    private var _y:int
    private var _freq:Number
    private var _start:Number
    private var _stop:Number

    private var _spawnTimer:Timer
    private var _monsterType:MonsterType

    public function get x():int {
        return _x
    }

    public function get y():int {
        return _y
    }

    public function get freq():Number {
        return _freq
    }

    public function get start():Number {
        return _start
    }

    public function get stop():Number {
        return _stop
    }

    public function MonsterSpawn(x:int, y:int, monsterType:MonsterType, freq:Number, start:Number = 0, stop:Number = 0) {
        _x = x
        _y = y
        _monsterType = monsterType
        _freq = freq
        _start = start
        _stop = stop

        Context.gameModel.gameStarted.addOnce(onGameStarted)
        Context.gameModel.leftGame.addOnce(stopSpawning)
    }

    private function onGameStarted():void {
        if (_start == 0)
            startSpawning()
        else
            TweenMax.delayedCall(_start, startSpawning)

        if (_stop != 0)
            TweenMax.delayedCall(_stop, stopSpawning)
    }

    private function stopSpawning():void {
        if (_spawnTimer.hasEventListener(TimerEvent.TIMER))
            _spawnTimer.removeEventListener(TimerEvent.TIMER, spawn)
    }

    private function startSpawning():void {
        _spawnTimer = new Timer(1000 / freq)
        _spawnTimer.addEventListener(TimerEvent.TIMER, spawn)
    }

    private function spawn(e:TimerEvent):void {
        if (Context.gameModel.isPlayingNow)
            EngineContext.needToAddMonster.dispatch(_monsterType, x, y)
    }
}
}
