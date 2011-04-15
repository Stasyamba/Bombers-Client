/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.EngineContext
import engine.bombers.interfaces.IPlayerBomber
import engine.data.Consts
import engine.interfaces.IDestroyable
import engine.utils.Direction

import flash.display.BitmapData

import greensock.TweenMax

import flash.display.Bitmap
import flash.display.Sprite

public class PlayerView extends BomberViewBase implements IDestroyable {

    private var playerPointer:Sprite;
    private var pulsesCount:int;

    private var pointerTween:TweenMax;

    public function PlayerView(bomber:IPlayerBomber) {
        super(bomber);

        EngineContext.playerCoordinatesChanged.add(updateCoords);
        EngineContext.playerInputDirectionChanged.add(onInputDirectionChanged);
        EngineContext.playerDied.add(onDied);
        EngineContext.playerDied.add(destroy);

        startPulsingPointer();

    }

    private function onInputDirectionChanged(x:Number, y:Number, dir:Direction, viewDirChanged:Boolean):void {
        if (_bomber.isDead)
            return;
        draw();
    }


    private function updateCoords(x:int, y:int):void {
        this.x = x;
        this.y = y;
    }

    private function drawPointer():void {
        playerPointer.graphics.beginBitmapFill(Context.imageService.playerPointer());
        playerPointer.graphics.drawRect(0, 0, 70, 80);
        playerPointer.graphics.endFill()
    }

    private function startPulsingPointer():void {
        playerPointer = new Sprite();
        addChild(playerPointer);
        drawPointer();

        pointerTween = TweenMax.to(playerPointer, Consts.POINTER_TIME, {
            alpha:0,
            onComplete:function():void {
                pointerTween.reverse()
            },
            onReverseComplete:function():void {
                pulsesCount++;
                if (pulsesCount > 7)
                    stopPulsingPointer();
                else
                    pointerTween.restart()
            }});

        playerPointer.x = -15;
        if (y < 20) {
            playerPointer.y = 115;
            playerPointer.rotationX = 180;
        }
        else {
            playerPointer.y = -75;
        }
        pulsesCount = 0;
    }

    private function stopPulsingPointer():void {
        pointerTween.kill();
        removeChild(playerPointer);

    }

    private function get bomber():IPlayerBomber {
        return _bomber as IPlayerBomber;
    }

    public function destroy():void {
    }
}
}