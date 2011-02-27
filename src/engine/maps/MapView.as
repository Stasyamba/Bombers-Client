/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import as3reflect.Constant

import components.common.worlds.locations.LocationType

import engine.data.Consts
import engine.data.location1.maps.MapBlocks
import engine.interfaces.IDestroyable
import engine.interfaces.IDrawable
import engine.maps.interfaces.IBigObject

import flash.display.BitmapData
import flash.display.Loader
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
        Context.imageService.backgroundLoaded.addOnce(function(obj:*):void{
            var bd : BitmapData = new BitmapData((obj as Loader).width,(obj as Loader).height)
            bd.draw(obj as Loader)

            graphics.beginBitmapFill(bd)
            graphics.drawRect(0,0,map.width * Consts.BLOCK_SIZE,map.height * Consts.BLOCK_SIZE)
            graphics.endFill()
        })
        Context.imageService.loadMapBackground(LocationType.WORLD1_GRASSFIELDS)

        for each (var obj:IBigObject in map.decorations) {
            var sp:Sprite = new Sprite()
            sp.graphics.beginBitmapFill(Context.imageService.getBigObject(obj.description.skin));
            sp.graphics.drawRect(0, 0, obj.description.width * Consts.BLOCK_SIZE, obj.description.height * Consts.BLOCK_SIZE);
            sp.graphics.endFill();
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