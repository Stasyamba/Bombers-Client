/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.profiles.interfaces {
import engine.bombers.interfaces.IGameSkills
import engine.bombers.skin.BomberSkin

public interface IGameProfile {
    function get name():String;

    function getGameSkills():IGameSkills;

    function getSkin(playerId:int):BomberSkin;
}
}