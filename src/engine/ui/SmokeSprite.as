/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.ui {
import engine.data.Consts

import engine.utils.greensock.TweenMax

import flash.display.BitmapData
import flash.display.Sprite

public class SmokeSprite extends Sprite {
    public function SmokeSprite(baseX:Number,baseY:Number) {
        super()
        var bm:BitmapData = Context.imageService.getSmoke()
        graphics.beginBitmapFill(bm)
        graphics.drawRect(0,0,Consts.SMOKE_WIDTH,Consts.SMOKE_HEIGHT)
        graphics.endFill()
        TweenMax.fromTo(this,20,
        {alpha:1,scaleX:0.5,scaleY:0.5,x:baseX - Consts.SMOKE_WIDTH/4,y:baseY - Consts.SMOKE_HEIGHT/4},
        {alpha:0.8,scaleX:1,scaleY:1,x:baseX - Consts.SMOKE_WIDTH/2,y:baseY - Consts.SMOKE_HEIGHT/2,onComplete:finish})
    }

    private function finish():void {
        TweenMax.to(this,1,{alpha:0,onComplete:destroy})
    }

    private function destroy():void {
        parent.removeChild(this)
    }
}
}
