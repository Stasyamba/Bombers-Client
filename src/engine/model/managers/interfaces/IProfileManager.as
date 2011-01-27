/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombers.interfaces.IGameSkills
import engine.bombers.skin.BomberSkin

public interface IProfileManager {

    function get name():String;

    function getMapSkills():IGameSkills;

    function getSkin():BomberSkin;
}
}