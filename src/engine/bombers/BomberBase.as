/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.bombers.BlockChanceObject
import components.common.bombers.BomberType

import engine.bombers.interfaces.IBomber
import engine.bombers.skin.BasicSkin
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.games.quest.monsters.ICreatureType
import engine.playerColors.PlayerColor
import engine.weapons.WeaponType

public class BomberBase extends CreatureBase implements IBomber {

    protected var _color:PlayerColor;

    protected var _userName:String;

    protected var _bomberType:BomberType;

    protected var _bombCount:int;
    protected var _bombPower:int;
    protected var _bombTaken:int

    protected var _critChance:Number
    protected var _blockChance:Number
    protected var _specialBlockChances:Array

    private var _auras:Array

    public function BomberBase(game:IGame, slot:int, bomberType:BomberType, userName:String, color:PlayerColor, skin:BasicSkin, auras:Array) {
        super(game, slot, bomberType)
        _color = color;
        _userName = userName;

        _bombPower = bomberType.bombPower;
        _bombCount = bomberType.bombCount;

        _auras = auras
    }

    public function get userName():String {
        return _userName;
    }

    public function get color():PlayerColor {
        return _color;
    }

    public override function get speed():Number {
        if (_explicitSpeed >= 0)
            return _explicitSpeed
        return _speed + getAurasSpeedBonus()
    }

    private function getAurasSpeedBonus():Number {
        return 0;
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

    public function get bomberType():BomberType {
        return _type as BomberType
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


    public function move(elapsedMilliSeconds:int):void {
        throw new Error("method BomberBase.move can't be called")
    }

    public function explode(expl:IExplosion):void {
        throw new Error("method BomberBase.explode can't be called")
    }

    public function kill():void {
        throw new Error("method BomberBase.kill can't be called")
    }

    public function hasAura(aura:WeaponType):Boolean {
        for (var i:int = 0; i < _auras.length; i++) {
            var weaponType:WeaponType = _auras[i];
            if (weaponType == aura)
                return true
        }
        return false
    }
}
}