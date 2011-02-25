/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss.view {
import engine.EngineContext
import engine.bombss.BombType
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.maps.mapBlocks.view.DestroyableSprite
import engine.maps.mapObjects.DynObjectType

import flash.display.BlendMode
import flash.display.Sprite

public class BombView extends DestroyableSprite implements IDrawable {
    private var block:IMapBlock;

    private var glow:Sprite = new Sprite;

    private var pulsing:Boolean = false;

    private static const TIME_TO_BOOM_WHEN_TO_FASTEN_PULSE:int = 600

    private var _baseView:Sprite

    public function BombView(block:IMapBlock, baseView:Sprite) {
        super();
        this.block = block;
        glow.blendMode = BlendMode.OVERLAY;
        addChild(glow);
        _baseView = baseView;

        this.block.objectCollected.add(onCollected)

    }

    private function onCollected(byMe:Boolean):void {
        destroy()
    }

    override public function destroy():void {
        block.objectCollected.remove(onCollected);
        if (_baseView.contains(this))
            _baseView.removeChild(this);
        EngineContext.frameEntered.remove(onPulse);
    }

    public override function draw():void {
        graphics.clear();
        if (block.object.type == DynObjectType.NULL || !(block.object.type is BombType)) {
            if (pulsing) stopPulsing();
            return;
        }
        if (!pulsing) startPulsing();

        graphics.beginBitmapFill(Context.imageService.getBomb(block.object.type as BombType, (block.object as ITimeActivatableDynObject).owner.color), null, false, true);
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
        if (block.object.type == DynObjectType.NULL || !(block.object.type is BombType))
            return
        if ((block.object as ITimeActivatableDynObject).timeToActivate < TIME_TO_BOOM_WHEN_TO_FASTEN_PULSE) {
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