/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.monsters {
import engine.data.Consts

import flash.utils.Dictionary

public class MonsterType implements ICreatureType {

    private var _id:String
    private var _graphicsId:String

    private var _value:int;
    private var _name:String;

    //game skills
    private var _speed:Number;
    private var _startLife:int
    private var _immortalTime:Number

    private var _damage:int

    public function get value():int {
        throw new Error("no value for monster")
    }

    public function get name():String {
        return _name
    }

    public function get id():String {
        return _id
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

    public function getViewSpeed(speed:Number):int {
        return  int(Math.round((Math.log(speed) - Math.log(_speed)) / Math.log(Consts.SPEED_BONUS_MULTIPLIER))) + 1
    }

    public function get graphicsId():String {
        return _graphicsId
    }

    public function MonsterType(id:String, graphicsId:String, speed:Number, startLife:int, immortalTime:Number, damage:int, name:String) {
        _id = id
        _graphicsId = graphicsId
        _name = name
        _speed = speed
        _startLife = startLife
        _damage = damage
        _immortalTime = immortalTime
    }

    //static stuff
    private static var _all:Dictionary = new Dictionary()

    public static function add(monsterType:MonsterType):void {
        if (_all[monsterType.id] != null)
            throw new Error("already have a monster with id = " + monsterType.id)
        _all[monsterType.id] = monsterType
    }

    public static function byId(id:String):MonsterType {
        var res:MonsterType = _all[id];
        if (res == null)
            throw new Error("no monster with id = " + id)
        return res
    }

    public function get damage():int {
        return _damage
    }
}
}
