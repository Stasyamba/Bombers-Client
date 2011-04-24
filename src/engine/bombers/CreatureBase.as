/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.bombers.interfaces.IGameSkin
import engine.bombers.interfaces.IMapCoords
import engine.bombers.mapInfo.MapCoords
import engine.data.Consts
import engine.games.IGame
import engine.games.quest.monsters.ICreatureType
import engine.maps.IMap
import engine.model.signals.StateAddedSignal
import engine.model.signals.StateRemovedSignal
import engine.utils.ViewState

import greensock.TweenMax

import org.osflash.signals.Signal

public class CreatureBase {
    protected var _game:IGame;
    protected var _map:IMap;

    protected var _coords:IMapCoords;
    protected var _gameSkin:IGameSkin;

    protected var _slot:int;

    protected var _life:int;
    protected var _startLife:int
    protected var _speed:Number;
    protected var _explicitSpeed:Number = -1;


    private var _isImmortal:Boolean;
    private var _becameImmortal:Signal = new Signal();
    private var _lostImmortal:Signal = new Signal();

    private var _stateAdded:StateAddedSignal = new StateAddedSignal();
    private var _stateRemoved:StateRemovedSignal = new StateRemovedSignal();

    private var _lifeChanged:Signal = new Signal();

    protected var _type:ICreatureType


    public function CreatureBase(game:IGame, slot:int, type:ICreatureType) {
        _game = game
        _slot = slot
        _type = type
        _life = type.startLife;
        _startLife = _life
        _speed = type.speed;
    }

    public function putOnMap(map:IMap, x:int, y:int):void {
        _map = map;
        _coords = new MapCoords(map, x, y, 0, 0);
    }

    public function incSpeed():void {
        _speed *= Consts.SPEED_BONUS_MULTIPLIER;
    }

    public function setSpeed(val:int):void {
        _explicitSpeed = val
    }

    public function resetSpeed():void {
        _explicitSpeed = -1
    }

    public function makeImmortalFor(secs:int, blink:Boolean = true):void {
        if (isDead || isImmortal)
            return;
        _isImmortal = true;
        if (blink) {
            stateAdded.dispatch(new ViewState(ViewState.BLINKING, {}, TweenMax.fromTo(new Object(), Consts.BLINKING_TIME, {alpha:0}, {alpha:ViewState.GET_DEFAULT_VALUE, repeat:-1,yoyo:true,paused:true,data:{alpha:ViewState.GET_DEFAULT_VALUE}})))
        }
        TweenMax.delayedCall(secs, function():void {
            _isImmortal = false;
            if (blink)
                stateRemoved.dispatch(ViewState.BLINKING);
        })
        becameImmortal.dispatch();
    }

    /*accessors*/

    public function get slot():int {
        return _slot;
    }

    public function get life():int {
        return _life;
    }

    public function get gameSkin():IGameSkin {
        return _gameSkin;
    }

    public function get coords():IMapCoords {
        return _coords;
    }


    public function get isImmortal():Boolean {
        return _isImmortal;
    }

    public function get becameImmortal():Signal {
        return _becameImmortal;
    }

    public function get lostImmortal():Signal {
        return _lostImmortal;
    }

    public function get lifeChanged():Signal {
        return _lifeChanged
    }

    public function set life(life:int):void {
        _life = life;
        _lifeChanged.dispatch()
    }

    public function get isDead():Boolean {
        return _life <= 0;
    }

    public function get stateAdded():StateAddedSignal {
        return _stateAdded;
    }

    public function get stateRemoved():StateRemovedSignal {
        return _stateRemoved;
    }

    public function get speed():Number {
        if (_explicitSpeed >= 0)
            return _explicitSpeed
        return _speed
    }

    public function get baseSpeed():Number {
        return _speed
    }

    public function get startLife():int {
        return _startLife
    }

    public function get immortalTime():int {
        return _type.immortalTime
    }

    public function get type():ICreatureType {
        return _type
    }
}
}
