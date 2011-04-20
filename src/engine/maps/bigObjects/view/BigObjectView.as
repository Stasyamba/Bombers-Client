/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects.view {
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.interfaces.IDrawable
import engine.maps.interfaces.IBigObject
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager
import greensock.TweenMax

import flash.display.BlendMode
import flash.display.Sprite

public class BigObjectView extends Sprite implements IDrawable,IStatedView {

    private var object:IBigObject;

    private var stateManager:ViewStateManager;

    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    public function BigObjectView(obj:IBigObject) {
        super();
        object = obj;
        x = obj.x * Consts.BLOCK_SIZE;
        y = obj.y * Consts.BLOCK_SIZE;

        stateManager = new ViewStateManager(this)

        obj.explosionStarted.add(onExplosionStarted)
        obj.explosionStopped.add(onExplosionStopped)
        obj.destroyed.add(onDestroyed)

        draw();

    }

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    private function onDestroyed():void {
        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(this.width / 2 - BasicDestroyExplosion.WIDTH / 2, this.height / 2 - BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))
    }

    private function onExplosionStopped():void {
        removeState(ViewState.BLINKING);
    }

    private function onExplosionStarted():void {
        addState(new ViewState(ViewState.BLINKING, {}, TweenMax.fromTo(new Object(), Consts.BLINKING_TIME, {alpha:0}, {alpha:ViewState.GET_DEFAULT_VALUE, repeat:-1,yoyo:true,paused:true,data:{alpha:ViewState.GET_DEFAULT_VALUE}})))
    }

    public function draw():void {
        graphics.clear();
        graphics.beginBitmapFill(Context.imageService.bigObject(object.description.skin));
        graphics.drawRect(0, 0, object.description.width * Consts.BLOCK_SIZE, object.description.height * Consts.BLOCK_SIZE);
        graphics.endFill();
    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x": return object.x * Consts.BLOCK_SIZE;
            case "y": return object.y * Consts.BLOCK_SIZE;
            case "alpha": return _defaultAlpha;
            case "blendMode":return BlendMode.NORMAL;
            case "scaleX": return 1.0;
            case "scaleY": return 1.0;
        }
        throw new ArgumentError("property " + prop + " is not supported")
    }
}
}