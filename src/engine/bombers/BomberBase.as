/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.bombers.BomberType

import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IGameSkin
import engine.bombers.interfaces.IMapCoords
import engine.bombers.mapInfo.MapCoords
import engine.bombers.skin.BomberSkin
import engine.bombers.skin.GameSkin
import engine.bombss.BombsBuilder
import engine.data.Consts
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.maps.IMap
import engine.model.signals.StateAddedSignal
import engine.model.signals.StateRemovedSignal
import engine.playerColors.PlayerColor
import engine.utils.ViewState
import engine.utils.greensock.TweenMax
import engine.weapons.interfaces.IWeapon

import org.osflash.signals.Signal

public class BomberBase implements IBomber {

    protected var game:IGame;
    protected var _map:IMap;
    protected var _bombBuilder:BombsBuilder;

    protected var _coords:IMapCoords;
    protected var _gameSkin:IGameSkin;
    protected var _color:PlayerColor;

    protected var _playerId:int;
    protected var _userName:String;

    protected var _bomberType:BomberType;

    protected var _life:int;
    protected var _speed:Number;
    protected var _bombCount:Number;
    protected var _bombPower:Number;
    protected var _bombTaken:int


    private var _isImmortal:Boolean;
    private var _becameImmortal:Signal = new Signal();
    private var _lostUntouchable:Signal = new Signal();

    private var _stateAdded:StateAddedSignal = new StateAddedSignal();
    private var _stateRemoved:StateRemovedSignal = new StateRemovedSignal();


    public function BomberBase(game:IGame, playerId:int,bomberType:BomberType, userName:String, color:PlayerColor, skin:BomberSkin, bombBuilder:BombsBuilder) {
        this.game = game;
        _playerId = playerId;
        _bombBuilder = bombBuilder;
        _gameSkin = new GameSkin(skin, color);
        _color = color;
        _userName = userName;

        _bomberType = bomberType
        _life = bomberType.startLife;
        _speed = bomberType.speed;
        _bombPower = bomberType.bombPower;
        _bombCount = bomberType.bombCount;
    }

    public function makeImmortalFor(secs:Number, blink:Boolean = true):void {
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

    public function putOnMap(map:IMap, x:int, y:int):void {
        _map = map;
        _coords = new MapCoords(map, x, y, 0, 0);
    }

    public function get userName():String {
        return _userName;
    }

    public function get playerId():int {
        return _playerId;
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
        return _lostUntouchable;
    }

    public function get color():PlayerColor {
        return _color;
    }

    public function set life(life:int):void {
        _life = life;
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
        return _speed + getAurasSpeedBonus()
    }

    private function getAurasSpeedBonus():Number {
        return 0;
    }

    public function get baseSpeed():Number {
        return _speed
    }

    public function get bombCount():int {
        return _bombCount + getAurasBombCountBonus() - _bombTaken;
    }

    private function getAurasBombCountBonus():int {
        return 0;
    }

    public function get baseBombCount():int {
        return _bombCount
    }

    public function get bombPower():int {
        return _bombPower + getAurasBombPowerBonus()
    }

    private function getAurasBombPowerBonus():int {
        return 0;
    }

    public function get baseBombPower():int {
        return _bombPower
    }

    public function incSpeed():void {
        _speed *= 1.1;
    }

    public function incBombCount():void {
        _bombCount++
    }

    public function incBombPower():void {
        _bombPower++
    }

    public function takeBomb():void {
        _bombTaken++;
    }

    public function returnBomb():void {
        _bombTaken--;
    }

    public function get immortalTime():Number {
        return 3.0
    }

    public function move(elapsedSeconds:Number):void {
        throw new Error("method BomberBase.move can't be called")
    }

    public function explode(expl:IExplosion):void {
        throw new Error("method BomberBase.explode can't be called")
    }

    public function kill():void {
        throw new Error("method BomberBase.kill can't be called")
    }

}
}