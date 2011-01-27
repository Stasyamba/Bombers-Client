/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IGameSkills
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
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IWeapon

import org.osflash.signals.Signal

public class BomberBase implements IBomber {

    protected var game:IGame;
    protected var _playerId:int;
    protected var _bombBuilder:BombsBuilder;

    protected var _map:IMap;
    protected var _skills:IGameSkills;

    protected var _coords:IMapCoords;
    protected var _gameSkin:IGameSkin;
    protected var _color:PlayerColor;
    protected var _life:int;
    protected var _weapon:IWeapon;

    private var _isImmortal:Boolean;

    private var _becameUntouchable:Signal = new Signal();
    private var _lostUntouchable:Signal = new Signal();

    private var _stateAdded:StateAddedSignal = new StateAddedSignal();
    private var _stateRemoved:StateRemovedSignal = new StateRemovedSignal();

    public function BomberBase(game:IGame, playerId:int, userName:String, color:PlayerColor, skills:IGameSkills, weapon:IWeapon, skin:BomberSkin, bombBuilder:BombsBuilder) {
        this.game = game;
        _playerId = playerId;
        _bombBuilder = bombBuilder;
        _skills = skills;
        _gameSkin = new GameSkin(skin, color);
        _color = color;
        _weapon = weapon;
        _userName = userName;

        _life = skills.startLife;
    }

    protected var _userName:String;

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
        becameUntouchable.dispatch();
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

    public function get gameSkills():IGameSkills {
        return _skills;
    }

    public function get weapon():IWeapon {
        return _weapon;
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

    public function get becameUntouchable():Signal {
        return _becameUntouchable;
    }

    public function get lostUntouchable():Signal {
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

    public function activateWeapon():void {
        if (weapon is IActivatableWeapon) {
            IActivatableWeapon(weapon).activate(_coords.elemX, coords.elemY, this);
        }
    }

    public function deactivateWeapon():void {
        if (weapon is IDeactivatableWeapon) {
            IDeactivatableWeapon(weapon).deactivate(_coords.elemX, coords.elemY, this);
        }
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