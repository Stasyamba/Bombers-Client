/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.EngineContext
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock

import flash.display.Sprite

import mx.collections.ArrayList

public class OverMapView extends Sprite implements IDrawable {

    private var map:IMap;
    private var prints:Vector.<Sprite>;

    public function OverMapView(map:IMap) {

        this.map = map;
        EngineContext.explosionsRemoved.add(function(list:ArrayList):void {
            draw();
        })

        prints = new Vector.<Sprite>();
        for each (var block:IMapBlock in map.blocks) {
            var print:Sprite = new Sprite();
            print.x = block.x * Consts.BLOCK_SIZE;
            print.y = block.y * Consts.BLOCK_SIZE;
            prints.push(print);
            addChild(print);
        }
    }

    private function getPrint(x:int, y:int):Sprite {
        return prints[y * map.width + x];
    }

    private function drawPrint(block:IMapBlock):void {
        var print:Sprite = getPrint(block.x, block.y);
        print.graphics.clear();
        if (block.hasExplosionPrint) {
            print.graphics.beginBitmapFill(Context.imageService.explosionPrint(block.explodedBy))
            print.graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
            print.graphics.endFill();
        }
    }

    public function draw():void {
        for each (var block:IMapBlock in map.blocks) {
            drawPrint(block);
        }
    }
}
}
