/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.skin {
import engine.utils.Direction

public class SkinInfo {
    public var skin:BasicSkin;
    public var currentSkin:SkinElement;

    public function updateSkin(dir:Direction):void {
        switch (dir) {
            case Direction.NONE:
                currentSkin = skin.none;
                break;
            case Direction.LEFT:
                currentSkin = skin.left;
                break;
            case Direction.RIGHT:
                currentSkin = skin.right;
                break;
            case Direction.UP:
                currentSkin = skin.up;
                break;
            case Direction.DOWN:
                currentSkin = skin.down;
                break;
            default:
                ArgumentError("Invalid direction code " + dir);
        }
    }

    public function SkinInfo(skin:BasicSkin, color:uint) {
        this.skin = skin;
        this.currentSkin = skin.none;
    }
}
}