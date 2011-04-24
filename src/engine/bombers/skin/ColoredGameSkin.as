/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.skin {
import engine.bombers.interfaces.IGameSkin
import engine.playerColors.PlayerColor
import engine.utils.Direction
import engine.utils.Pixel

import flash.display.BitmapData
import flash.display.Sprite

public class ColoredGameSkin implements IGameSkin {

    private var _skin:BasicSkin;
    private var _currentSkin:SkinElement;

    public function get isColored():Boolean {
        return true
    }

    private var _color:PlayerColor;
    private var masks:Object = new Object();
    private var _currentMask:Sprite;

    public function ColoredGameSkin(skin:BasicSkin, color:PlayerColor) {
        _skin = skin;
        this.color = color;
        masks.left = getMask(Direction.LEFT)
        masks.right = getMask(Direction.RIGHT)
        masks.up = getMask(Direction.UP)
        masks.down = getMask(Direction.DOWN)
        masks.none = getMask(Direction.NONE)

        _currentMask = masks[Direction.NONE.key];
        _currentSkin = skin.skinElements[Direction.NONE.key];

    }

    public function updateSkin(dir:Direction):void {
        _currentSkin = _skin.skinElements[dir.key];
        _currentMask = masks[dir.key];
    }

    public function get color():PlayerColor {
        return _color;
    }

    public function set color(value:PlayerColor):void {
        _color = value;
    }

    public function get skin():BasicSkin {
        return _skin;
    }

    public function get currentSkin():SkinElement {
        return _currentSkin;
    }

    public function get currentMask():Sprite {
        return _currentMask;
    }

    private function getMask(dir:Direction):Sprite {
        var sp:Sprite = new Sprite();

        var bData:BitmapData = (_skin.skinElements[dir.key] as SkinElement).mask.bitmapData;
        var col:int = _skin.colors[color.key].color;
        var blendMode:String = _skin.colors[color.key].blendMode
        var opacity:Number = _skin.colors[color.key].opacity;

        for (var i:int = 0; i <= bData.width - 1; i++) {
            for (var j:int = 0; j <= bData.height - 1; j++) {
                var px:Pixel = new Pixel(bData.getPixel32(i, j));
                if (px.getAlpha() > 240) {
                    sp.graphics.beginFill(col);
                    sp.graphics.drawRect(i, j, 1, 1);
                    sp.graphics.endFill();
                }
            }
        }
        sp.alpha = opacity;
        sp.blendMode = blendMode;
        return sp;
    }
}
}