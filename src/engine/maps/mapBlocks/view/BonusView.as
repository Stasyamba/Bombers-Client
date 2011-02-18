/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.utils.greensock.TweenMax

import flash.display.Sprite

public class BonusView extends DestroyableSprite implements IDrawable {

    private var block:IMapBlock;
    private var _baseView:Sprite;

    public function BonusView(block:IMapBlock, baseView:Sprite) {
        super()
        this.block = block;
        this.block.objectCollected.add(onTakenAnimation)
        _baseView = baseView;
    }

    public override function draw():void {
        graphics.clear();
        if (block.object.type == DynObjectType.NULL)
            return;
        graphics.beginBitmapFill(Context.imageService.getObject(block.object.type));
        graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
        graphics.endFill();
    }

    public function onTakenAnimation(byMe:Boolean):void {
        if (byMe)
            TweenMax.to(this, 1, {x:"60",y:"-40",rotation:"360",scaleX:0,scaleY:0,alpha:0,onComplete:destroy});
        else
            TweenMax.to(this, 0.7, {x:"20",y:"20",scaleX:0,scaleY:0,alpha:0,onComplete:destroy});
    }

    override public function destroy():void {
        block.objectCollected.remove(onTakenAnimation);
        if (_baseView.contains(this))
            _baseView.removeChild(this);
    }
}
}