/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombers.skin.BomberSkin
import engine.bombers.skin.SkinElement
import engine.playerColors.PlayerColor
import engine.utils.Direction

import flash.display.Sprite

public interface IGameSkin {
    function updateSkin(dir:Direction):void;

    function get skin():BomberSkin;

    function get currentSkin():SkinElement;

    function get isColored():Boolean
}
}