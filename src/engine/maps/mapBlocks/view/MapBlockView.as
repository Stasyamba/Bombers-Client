/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.EngineContext
import engine.bombss.view.BombView
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.maps.mapObjects.MapObjectType

import flash.display.BitmapData
import flash.display.Sprite

public class MapBlockView extends Sprite implements IDrawable {

    private var block:IMapBlock;
    private var blinking:Boolean = false;
    private var blinkingTime:Number = Consts.BLINKING_TIME;

    private var bombView:BombView;
    private var objectView:DestroyableSprite;

    public function MapBlockView(block:IMapBlock) {
        super();
        this.block = block;
        x = block.x * Consts.BLOCK_SIZE;
        y = block.y * Consts.BLOCK_SIZE;

        block.viewUpdated.add(draw);

        block.explosionStarted.add(function():void {
            EngineContext.frameEntered.add(onBlink)
            blinking = true;
            draw();
        })
        block.explosionStopped.add(function():void {
            EngineContext.frameEntered.remove(onBlink)
            blinking = false;
        })
        bombView = new BombView(block);

        block.objectSet.add(onObjectSet);
        block.objectCollected.add(onObjectCollected);

        addChild(bombView);
        draw();
    }

    private function onObjectCollected(byMe:Boolean):void {

    }

    private function onObjectSet(object:IMapObject):void {
        if (objectView != null)
            objectView.destroy();
        objectView = ObjectViewFactory.make(object, this);
        addChild(objectView);
        draw();
    }

    private function onBlink(elapsedMilliSecs:int):void {
        if (!block.isExplodingNow) {
            blinking = false;
            draw();
            return
        }
        blinkingTime -= elapsedMilliSecs / 1000;
        if (blinkingTime <= 0) {
            blinkingTime += Consts.BLINKING_TIME;
            draw();
            blinking = !blinking;
        }
    }

    public function draw():void {
        graphics.clear();

        drawBlock();

        drawBomb();
        drawObject();
        drawHiddenObject();
    }

    private function drawHiddenObject():void {
        if (block.isExplodingNow && block.hiddenObject.type != MapObjectType.NULL) {
            trace("DRAWN HIDDEN")
            graphics.beginBitmapFill(Context.imageService.getObject(block.hiddenObject.type));
            graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
            graphics.endFill();
        }
    }

    private function drawBomb():void {
        bombView.draw();
    }

    private function drawObject():void {
        if (objectView != null) {
            objectView.draw();
            objectView.visible = block.canShowObjects;
        }
    }

    private function drawBlock():void {
        if (blinking) return;
        var bData:BitmapData = Context.imageService.getMapBlock(block.type)
        if (bData == null) return;
        graphics.beginBitmapFill(bData);
        graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
        graphics.endFill();
    }
}
}