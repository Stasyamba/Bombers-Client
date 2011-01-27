/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.bombers.interfaces.IBomber
import engine.bombers.skin.SkinElement
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.interfaces.IDrawable
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager
import engine.utils.greensock.TweenMax

import flash.display.BlendMode
import flash.display.Sprite

public class BomberViewBase extends Sprite implements IDrawable,IStatedView {

    protected var _bomber:IBomber;

    protected var healthBar:Sprite = new Sprite();

    protected var _mask:Sprite;

    private var stateManager:ViewStateManager;

    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    public function BomberViewBase(bomber:IBomber) {
        super();
        _bomber = bomber;
        this.x = bomber.coords.getRealX();
        this.y = bomber.coords.getRealY();
        healthBar = new Sprite();
        healthBar.x = int((Consts.BLOCK_SIZE - Consts.HEALTH_BAR_WIDTH) / 2)
        healthBar.y = -4;
        addChild(healthBar);

        stateManager = new ViewStateManager(this);

        this._bomber.stateAdded.add(addState);
        this._bomber.stateRemoved.add(removeState);
        draw();
    }

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    public function draw():void {
        if (_mask != null && this.contains(_mask))
            removeChild(_mask);

        if (_bomber.isDead) {
            graphics.clear()
            removeChild(healthBar);
            return;
        }

        drawHealthBar();

        graphics.clear();

        var directionSkin:SkinElement = _bomber.gameSkin.currentSkin;

        graphics.beginBitmapFill(directionSkin.skin.bitmapData);
        graphics.drawRect(0, 0, Consts.BOMBER_SIZE, Consts.BOMBER_SIZE);
        graphics.endFill();

        rotation = 0;

        _mask = _bomber.gameSkin.currentMask;
        addChildAt(_mask, 0);
    }

    private function drawHealthBar():void {
        healthBar.graphics.clear();
        healthBar.graphics.beginBitmapFill(Context.imageService.getHealthBar(_bomber.life / _bomber.gameSkills.startLife));
        healthBar.graphics.drawRect(0, 0, Consts.HEALTH_BAR_WIDTH, Consts.HEALTH_BAR_HEIGHT)
        healthBar.graphics.endFill();
    }

    protected function onDied():void {
        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(19 - BasicDestroyExplosion.WIDTH / 2, 19 - BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))

    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x": return _bomber.coords.getRealX();
            case "y": return _bomber.coords.getRealY();
            case "alpha": return _defaultAlpha;
            case "blendMode":return BlendMode.NORMAL;
            case "scaleX": return 1.0;
            case "scaleY": return 1.0;
        }
        throw new ArgumentError("property " + prop + " is not supported")
    }
}
}