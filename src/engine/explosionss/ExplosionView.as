/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.EngineContext
import engine.data.Consts
import engine.explosionss.interfaces.IExplosion
import engine.interfaces.IDestroyable
import engine.interfaces.IDrawable
import engine.model.explosionss.ExplosionType

import flash.display.Sprite

public class ExplosionView extends Sprite implements IDrawable,IDestroyable {

    private var explosion:IExplosion;

    public function ExplosionView() {
        super();
        EngineContext.explosionsUpdated.add(onExplosionsUpdated)
        draw();
    }

    private function onExplosionsUpdated(expl:IExplosion):void {
        explosion = expl;
        draw();
    }

    public function draw():void {
        graphics.clear();
        if (explosion != null && explosion.type != ExplosionType.NULL) {
            explosion.forEachPoint(function(point:ExplosionPoint):void {
                graphics.beginBitmapFill(Context.imageService.getExplosion(explosion.type, point.type));
                graphics.drawRect(point.x * Consts.BLOCK_SIZE, point.y * Consts.BLOCK_SIZE, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
                graphics.endFill();
            })
        }
    }


    public function destroy():void {
        EngineContext.explosionsUpdated.removeAll()
    }
}
}