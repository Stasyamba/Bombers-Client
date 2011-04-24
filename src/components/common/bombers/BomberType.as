package components.common.bombers {
import components.common.items.ItemType

import engine.games.quest.monsters.ICreatureType

import loading.LoaderUtils

public class BomberType implements ICreatureType {

    public static const FURY_JOE:BomberType = new BomberType(0, "FURY_JOE", "b00", ItemType.BASE_BOMB, 1, 1, 100, 3, 0.05, 0.05);
    public static const R2D3:BomberType = new BomberType(1, "R2D3", "b00", ItemType.BASE_BOMB, 1, 1, 100, 3, 0.05, 0.05);

    private var _value:int;
    private var _name:String;
    private var _graphicsId:String
    private var _baseBomb:ItemType;

    //game skills
    private var _bombCount:int;
    private var _bombPower:int;
    private var _speed:Number;
    private var _startLife:int
    private var _critChance:Number
    private var _blockChance:Number
    private var _specialBlockChances:Array = new Array()
    private var _specialCritChances:Array = new Array()
    private var _immortalTime:Number


    public static function initBlocks():void {
        R2D3._specialBlockChances.push(new BlockChanceObject(R2D3, 0.5))
    }


    public function BomberType(value:int, name:String, graphicsId:String, baseBomb:ItemType, bombCount:int, bombPower:int, speed:Number, startLife:int, critChance:Number, blockChance:Number, immortalTime:Number = 3.0) {
        _value = value
        _name = name
        _graphicsId = graphicsId
        _baseBomb = baseBomb
        _bombCount = bombCount
        _bombPower = bombPower
        _speed = speed
        _startLife = startLife
        _critChance = critChance
        _blockChance = blockChance
    }

    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function get stringId():String {
        return "b" + LoaderUtils.stringId(_value)
    }

    public function get baseBomb():ItemType {
        return _baseBomb
    }

    public static function byValue(value:int):BomberType {
        switch (value) {
            case FURY_JOE.value:
                return FURY_JOE
            case R2D3.value:
                return R2D3
        }
        throw new ArgumentError("no BomberType found with value = " + value);
    }

    public function get bombCount():int {
        return _bombCount
    }

    public function get bombPower():int {
        return _bombPower
    }

    public function get speed():Number {
        return _speed
    }

    public function get startLife():int {
        return _startLife
    }

    public function get immortalTime():Number {
        return _immortalTime
    }

    public function get critChance():Number {
        return _critChance
    }

    public function get blockChance():Number {
        return _blockChance
    }

    public function get specialBlockChances():Array {
        return _specialBlockChances
    }

    public function get specialCritChances():Array {
        return _specialCritChances
    }

    public function getViewSpeed(speed:Number):int {
        return int(Math.round((Math.log(speed) - Math.log(_speed)) / Math.log(1.1))) + 1
    }

    public static function byStringId(sID:String):BomberType {
        var i:int = int(sID.substr(1))
        return byValue(i)
    }

    public function get id():String {
        return String(value)
    }

    public static function add(t:BomberType):void {
        //todo:implement
    }
}
}