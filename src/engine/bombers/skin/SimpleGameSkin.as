/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombers.skin {
import engine.bombers.interfaces.IGameSkin
import engine.utils.Direction

public class SimpleGameSkin implements IGameSkin {

    private var _skin:BomberSkin;
    private var _currentSkin:SkinElement;

    public function get isColored():Boolean {
        return false
    }

    private var masks:Object = new Object();

    public function SimpleGameSkin(skin:BomberSkin) {
        _skin = skin;
        _currentSkin = skin.skinElements[Direction.NONE.key];

    }

    public function updateSkin(dir:Direction):void {
        _currentSkin = _skin.skinElements[dir.key];
    }

    public function get skin():BomberSkin {
        return _skin;
    }

    public function get currentSkin():SkinElement {
        return _currentSkin;
    }

}
}
