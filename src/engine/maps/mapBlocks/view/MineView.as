/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.MapObjectType
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager
import engine.utils.greensock.TweenMax

import flash.display.BlendMode
import flash.display.Sprite

public class MineView extends DestroyableSprite implements IStatedView {
    private var block:IMapBlock;
    private var _baseView:Sprite;

    /*stated view*/
    private var stateManager:ViewStateManager;
    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    public function MineView(block:IMapBlock, baseView:Sprite) {
        super();
        this.block = block;
        this.block.objectCollected.add(onTakenAnimation)
        _baseView = baseView;

        stateManager = new ViewStateManager(this)
    }

    public override function draw():void {
        graphics.clear();
        if (block.object.type == MapObjectType.NULL)
            return;
        graphics.beginBitmapFill(Context.imageService.getObject(block.object.type));
        graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
        graphics.endFill();
    }

    public function onTakenAnimation(byMe:Boolean):void {

        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(BasicDestroyExplosion.WIDTH / 2, BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))
    }

    override public function destroy():void {
        block.objectCollected.remove(onTakenAnimation);
        if (_baseView.contains(this))
            _baseView.removeChild(this);
    }

    /*stated view*/

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x": return block.x * Consts.BLOCK_SIZE;
            case "y": return block.y * Consts.BLOCK_SIZE;
            case "alpha": return _defaultAlpha;
            case "blendMode":return BlendMode.NORMAL;
            case "scaleX": return 1.0;
            case "scaleY": return 1.0;
        }
        throw new ArgumentError("property " + prop + " is not supported")
    }
}
}
