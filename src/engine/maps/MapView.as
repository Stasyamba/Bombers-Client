/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import components.common.worlds.locations.LocationType

import engine.data.Consts
import engine.interfaces.IDestroyable
import engine.interfaces.IDrawable
import engine.maps.bigObjects.BigObjectBase

import flash.display.BitmapData
import flash.display.Sprite

public class MapView extends Sprite implements IDrawable,IDestroyable {


    public var map:IMap;


    public function draw():void {
        graphics.clear();
        drawBackground();
    }

    public function drawBackground():void {

        removeAllChildren();

        //todo:real location
        var bd:BitmapData = Context.imageService.mapBackground(LocationType.WORLD1_GRASSFIELDS)

        graphics.beginBitmapFill(bd)
        graphics.drawRect(0, 0, map.width * Consts.BLOCK_SIZE, map.height * Consts.BLOCK_SIZE)
        graphics.endFill()


        for each (var obj:BigObjectBase in map.decorations) {
            var sp:Sprite = new Sprite()
//            sp.graphics.beginBitmapFill(Context.imageService.bigObject(obj.description.skin));
//            sp.graphics.drawRect(0, 0, obj.description.width * Consts.BLOCK_SIZE, obj.description.height * Consts.BLOCK_SIZE);
//            sp.graphics.endFill();
            sp.x = obj.x * Consts.BLOCK_SIZE;
            sp.y = obj.y * Consts.BLOCK_SIZE;
            addChild(sp);
        }
    }

    private function removeAllChildren():void {
        while (numChildren != 0) {
            removeChildAt(0);
        }
    }

    public function MapView(map:IMap) {
        super();
        this.map = map;
        draw();
    }

    public function destroy():void {

    }
}
}