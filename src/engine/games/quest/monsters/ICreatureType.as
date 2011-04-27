/*
 * Copyright (c) 2011. 
 * Pavkin Vladimir
 */

package engine.games.quest.monsters {
public interface ICreatureType {

    function get value():int

    function get name():String

    function get id():String

    function get speed():Number

    function get startLife():int

    function get immortalTime():Number

    function get graphicsId():String

    function getViewSpeed(speed:Number):int

}
}
