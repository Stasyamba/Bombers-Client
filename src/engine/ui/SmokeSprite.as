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
    private var _baseX:Number
    private var _baseY:Number
    public function SmokeSprite(baseX:Number,baseY:Number) {
        super()
        _baseX = baseX
        _baseY = baseY
    }

    public function start():void {
        var bm:BitmapData = Context.imageService.getSmoke()
        graphics.beginBitmapFill(bm)
        graphics.drawRect(0,0,Consts.SMOKE_WIDTH,Consts.SMOKE_HEIGHT)
        graphics.endFill()
        TweenMax.fromTo(this,5,
        {alpha:1,scaleX:0.5,scaleY:0.5,x:_baseX + Consts.BLOCK_SIZE_2 - Consts.SMOKE_WIDTH/4,y:_baseY + Consts.BLOCK_SIZE_2  - Consts.SMOKE_HEIGHT/4},
        {alpha:1,scaleX:1,scaleY:1,x:_baseX + Consts.BLOCK_SIZE_2  - Consts.SMOKE_WIDTH/2,y:_baseY + Consts.BLOCK_SIZE_2  - Consts.SMOKE_HEIGHT/2,onComplete:defaultState})
    }
    private function defaultState():void {
         TweenMax.to(this,20,
        {alpha:1,scaleX:1.5,scaleY:1.5,x:_baseX + Consts.BLOCK_SIZE_2  - 1.5*Consts.SMOKE_WIDTH/2,y:_baseY + Consts.BLOCK_SIZE_2  - 1.5*Consts.SMOKE_HEIGHT/2,onComplete:finish})
    }

    private function finish():void {
        TweenMax.to(this,1,{alpha:0,onComplete:destroy})
    }

    private function destroy():void {
        parent.removeChild(this)
    }
}
}
