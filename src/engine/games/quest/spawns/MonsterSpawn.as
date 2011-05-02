/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.spawns {
import engine.EngineContext
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.WalkingStrategy

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

    private var _wsXML:XML

    private var _spawnedCount:int = 0
    private var _maxCount:int

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

    public function MonsterSpawn(x:int, y:int, monsterType:MonsterType, freq:Number, ws:XML, start:Number = 0, stop:Number = 0, maxCount:int = 0) {
        _x = x
        _y = y
        _monsterType = monsterType
        _freq = freq
        _start = start
        _stop = stop

        _wsXML = ws

        if(maxCount > 0)
            _maxCount = maxCount
        else
            _maxCount = int.MAX_VALUE

        Context.gameModel.questStarted.addOnce(onGameStarted)
        Context.gameModel.questEnded.addOnce(stopSpawning)
    }

    private function onGameStarted():void {
        if (_start == 0)
            startSpawning()
        else
            TweenMax.delayedCall(_start, startSpawning)

        if (_stop != 0)
            TweenMax.delayedCall(_stop, stopSpawning,[null,null])
    }

    private function stopSpawning(p0:*,p1:*):void {
        _spawnTimer.stop()
        if (_spawnTimer.hasEventListener(TimerEvent.TIMER))
            _spawnTimer.removeEventListener(TimerEvent.TIMER, spawn)
    }

    private function startSpawning():void {
        _spawnTimer = new Timer(1000 / freq)
        _spawnTimer.addEventListener(TimerEvent.TIMER, spawn)
        _spawnTimer.start()
    }

    private function spawn(e:TimerEvent):void {
        if (Context.gameModel.isPlayingNow && _spawnedCount < _maxCount){
            EngineContext.qNeedToAddMonster.dispatch(_monsterType, x, y, WalkingStrategy.xml(_wsXML))
            _spawnedCount++
        }
    }
}
}
