/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.bombers.BlockChanceObject
import components.common.bombers.BomberType

import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IGameSkin
import engine.bombers.interfaces.IMapCoords
import engine.bombers.mapInfo.MapCoords
import engine.bombers.skin.BomberSkin
import engine.bombers.skin.ColoredGameSkin
import engine.bombers.skin.SimpleGameSkin
import engine.data.Consts
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.maps.IMap
import engine.model.signals.StateAddedSignal
import engine.model.signals.StateRemovedSignal
import engine.playerColors.PlayerColor
import engine.utils.ViewState
import engine.weapons.WeaponType

import greensock.TweenMax

import org.osflash.signals.Signal

public class BomberBase implements IBomber {

    protected var game:IGame;
    protected var _map:IMap;

    protected var _coords:IMapCoords;
    protected var _gameSkin:IGameSkin;
    protected var _color:PlayerColor;

    protected var _slot:int;
    protected var _userName:String;

    protected var _bomberType:BomberType;

    protected var _life:int;
    protected var _startLife:int
    protected var _speed:Number;
    protected var _explicitSpeed:Number = -1;
    protected var _bombCount:int;
    protected var _bombPower:int;
    protected var _bombTaken:int

    protected var _critChance:Number
    protected var _blockChance:Number
    protected var _specialBlockChances:Array

    private var _isImmortal:Boolean;
    private var _becameImmortal:Signal = new Signal();
    private var _lostUntouchable:Signal = new Signal();

    private var _stateAdded:StateAddedSignal = new StateAddedSignal();
    private var _stateRemoved:StateRemovedSignal = new StateRemovedSignal();

    private var _lifeChanged:Signal = new Signal();

    private var _auras:Array

    public function BomberBase(game:IGame, slot:int, bomberType:BomberType, userName:String, color:PlayerColor, skin:BomberSkin, auras:Array) {
        this.game = game;
        _slot = slot;
        if (color == null)
            _gameSkin = new SimpleGameSkin(skin)
        else
            _gameSkin = new ColoredGameSkin(skin, color);
        _color = color;
        _userName = userName;

        _bomberType = bomberType
        _life = bomberType.startLife;
        _startLife = _life
        _speed = bomberType.speed;
        _bombPower = bomberType.bombPower;
        _bombCount = bomberType.bombCount;

        _auras = auras
    }

    public function makeImmortalFor(millisecs:int, blink:Boolean = true):void {
        if (isDead || isImmortal)
            return;
        _isImmortal = true;
        if (blink) {
            stateAdded.dispatch(new ViewState(ViewState.BLINKING, {}, TweenMax.fromTo(new Object(), Consts.BLINKING_TIME, {alpha:0}, {alpha:ViewState.GET_DEFAULT_VALUE, repeat:-1,yoyo:true,paused:true,data:{alpha:ViewState.GET_DEFAULT_VALUE}})))
        }
        TweenMax.delayedCall(millisecs / 1000, function():void {
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
        return _lostUntouchable;
    }

    public function get lifeChanged():Signal {
        return _lifeChanged
    }

    public function get color():PlayerColor {
        return _color;
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

    public function get baseBlockChance():Number {
        return _blockChance
    }

    public function get baseCritChance():Number {
        return _critChance
    }

    public function getTotalBlockChance(bt:BomberType):Number {
        var sbc:Number = 0
        for (var i:int = 0; i < _specialBlockChances.length; i++) {
            var bco:BlockChanceObject = _specialBlockChances[i];
            if (bco.bomberType == bt) {
                sbc += bco.blockChance
            }
        }
        return sbc + _blockChance
    }

    public function incSpeed():void {
        _speed *= 1.1;
    }

    public function setSpeed(val:int):void {
        _explicitSpeed = val
    }

    public function resetSpeed():void {
        _explicitSpeed = -1
    }

    public function incBombCount():void {
        _bombCount++
    }

    public function incBombPower():void {
        _bombPower++
    }

    public function takeBomb():void {
        _bombTaken++;
        trace("bomb taken")
    }

    public function returnBomb():void {
        _bombTaken--;
        trace("bomb returned")
    }

    public function get immortalTime():int {
        return 3000
    }

    public function move(elapsedMilliSeconds:int):void {
        throw new Error("method BomberBase.move can't be called")
    }

    public function explode(expl:IExplosion):void {
        throw new Error("method BomberBase.explode can't be called")
    }

    public function hasAura(aura:WeaponType):Boolean {
        for (var i:int = 0; i < _auras.length; i++) {
            var weaponType:WeaponType = _auras[i];
            if (weaponType == aura)
                return true
        }
        return false
    }

    public function kill():void {
        throw new Error("method BomberBase.kill can't be called")
    }

    public function get startLife():int {
        return _startLife
    }
}
}