/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.explosionss.destroy {
import engine.utils.greensock.TweenMax

import flash.display.BlendMode
import flash.display.Sprite

public class BasicDestroyExplosion {

    public static const WIDTH:Number = 153;
    public static const HEIGHT:Number = 159;

    public static function getChild(x:int, y:int):Sprite {
        var child:Sprite = new Sprite();

        for (var i:int = 0; i < 3; i++) {
            var expl:Sprite = new Sprite();
            expl.graphics.beginBitmapFill(Context.imageService.getDieExplosion(i))
            expl.graphics.drawRect(0, 0, 153, 159);
            expl.graphics.endFill();
            expl.x = x;
            expl.y = y;
            expl.alpha = 0;
            if (i > 0)
                expl.blendMode = BlendMode.OVERLAY;
            child.addChild(expl);
        }
        return child;
    }

    public static function getTween():TweenMax {
        var tween:TweenMax = TweenMax.to(new Object(), 0.5, {alpha:0,paused:true,delay:0.7});
        return tween;
    }

    public static function getChildTween(child:Sprite):TweenMax {
        var childTween:TweenMax = TweenMax.to(child.getChildAt(0), 0.3, {alpha:1,paused:true,onComplete:function():void {
            TweenMax.to(child.getChildAt(1), 0.3, {alpha:1,onComplete: function():void {
                TweenMax.to(child.getChildAt(2), 0.3, {alpha:1,onComplete:function():void {
                    TweenMax.to(child, 0.3, {alpha:0})
                }})
            }})
        }});
        return childTween;
    }
}
}
