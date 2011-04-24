/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombers.skin.BasicSkin
import engine.bombers.skin.SkinElement
import engine.utils.Direction

public interface IGameSkin {
    function updateSkin(dir:Direction):void;

    function get skin():BasicSkin;

    function get currentSkin():SkinElement;

    function get isColored():Boolean
}
}