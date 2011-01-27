/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss.view {
import engine.EngineContext
import engine.bombss.NullBomb
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock

import flash.display.BlendMode
import flash.display.Sprite

public class BombView extends Sprite implements IDrawable {
    private var block:IMapBlock;

    private var glow:Sprite = new Sprite;

    private var pulsing:Boolean = false;

    private static const TIME_TO_BOOM_WHEN_TO_FASTEN_PULSE:Number = 0.6


    public function BombView(block:IMapBlock) {
        super();
        this.block = block;
        glow.blendMode = BlendMode.OVERLAY;
        addChild(glow);
    }

    public function draw():void {
        graphics.clear();
        if (block.bomb is NullBomb) {
            if (pulsing) stopPulsing();
            return;
        }
        if (!pulsing) startPulsing();

        graphics.beginBitmapFill(Context.imageService.getBomb(block.bomb.type, block.bomb.owner.color), null, false, true);
        graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
        graphics.endFill();
    }

    private function stopPulsing():void {
        pulsing = false;
        EngineContext.frameEntered.remove(onPulse);
    }

    private function startPulsing():void {
        pulsing = true;
        EngineContext.frameEntered.add(onPulse);
    }

    private function onPulse(elapsedMilliSecs:int):void {
        var offset:Number;
        var scale:Number;
        if (block.bomb.timeToExplode < TIME_TO_BOOM_WHEN_TO_FASTEN_PULSE) {
            offset = BombPulseSynchronizer.fastOffset;
            scale = BombPulseSynchronizer.fastScale;
        } else {
            offset = BombPulseSynchronizer.pulseOffset;
            scale = BombPulseSynchronizer.pulseScale;
        }
        x = offset;
        y = offset;
        scaleX = scale;
        scaleY = scale;
    }
}
}