/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.ui {
import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.view.EnemyView
import engine.bombers.view.MonsterView
import engine.bombers.view.PlayerView
import engine.data.Consts
import engine.explosionss.ExplosionView
import engine.games.IGame
import engine.games.quest.monsters.Monster
import engine.games.regular.RegularGame
import engine.interfaces.IDestroyable
import engine.interfaces.IDrawable
import engine.maps.MapView
import engine.maps.OverMapView
import engine.maps.bigObjects.view.BigObjectsView
import engine.maps.mapBlocks.view.MapBlocksView

import flash.display.Sprite
import flash.events.Event
import flash.geom.Point

import greensock.TweenMax

import mx.collections.ArrayList
import mx.controls.Label
import mx.core.UIComponent

import spark.components.Group

public class GameFieldView extends Group implements IDrawable,IDestroyable {

    private var game:IGame;
    /*--- layers from bottom to top*/

    //background and background objects
    public var mapView:MapView;
    //a layer between explosions and map. now is used to draw explosion prints
    public var overMapView:OverMapView;
    //bomb explosions (no die explosions here)
    public var explosionsView:ExplosionView;
    //interactive big objects players walk on
    public var lowerBigObjectsView:BigObjectsView;
    //map blocks : boxes,walls and so on
    public var mapBlocksView:MapBlocksView;
    //enemies
    public var enemiesViews:ArrayList = new ArrayList();
    public var enemiesView:Sprite = new Sprite()
    //player
    public var playerView:PlayerView;
    //interactive big objects players walk under
    public var higherBigObjectsView:BigObjectsView;
    //for smoke and other stuff like that
    public var highestView:Sprite = new Sprite()

    private var contentUI:UIComponent = new UIComponent();

    private static const VIEWPORT_WIDTH:Number = 680;

    private static const VIEWPORT_HEIGHT:Number = 440;

    public function GameFieldView(game:IGame) {
        super();
        this.game = game;

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        mapView = new MapView(game.mapManager.map);
        contentUI.addChild(mapView);

        overMapView = new OverMapView(game.mapManager.map);
        contentUI.addChild(overMapView);

        explosionsView = new ExplosionView();
        contentUI.addChild(explosionsView);

        lowerBigObjectsView = new BigObjectsView(game.mapManager.map, false)
        contentUI.addChild(lowerBigObjectsView);

        mapBlocksView = new MapBlocksView(game.mapManager.map)
        contentUI.addChild(mapBlocksView);

        if (game is RegularGame) {
            (game as RegularGame).enemiesManager.forEachAliveEnemy(function todo(item:IEnemyBomber, slot:int):void {
                var enemyView:EnemyView = new EnemyView(item);
                enemiesViews.addItem(enemyView);
                enemiesView.addChild(enemyView);
            })
        }

        game.monstersManager.forEachAliveMonster(function todo(item:Monster, slot:int):void {
            var monsterView:MonsterView = new MonsterView(item);
            enemiesViews.addItem(monsterView);
            enemiesView.addChild(monsterView);
        })
        contentUI.addChild(enemiesView)

        playerView = new PlayerView(game.playerManager.me);
        contentUI.addChild(playerView);

        higherBigObjectsView = new BigObjectsView(game.mapManager.map, true);
        contentUI.addChild(higherBigObjectsView);

        contentUI.addChild(highestView)

        this.clipAndEnableScrolling = true;
        this.width = VIEWPORT_WIDTH;
        this.height = VIEWPORT_HEIGHT;

        onPlayerCoordinatesChanged(game.playerManager.me.coords.getRealX(), game.playerManager.me.coords.getRealY())
        EngineContext.playerCoordinatesChanged.add(onPlayerCoordinatesChanged);
        EngineContext.smokeAdded.add(onSmokeAdded)

        EngineContext.qMonsterAdded.add(onMonsterAdded)

        EngineContext.redBaloon.add(function(p1:Point, p2:Point):void {
            var sp:Sprite = new Sprite()
            sp.graphics.beginFill(0xFF0000, 0.8)
            sp.graphics.drawRect(0, 0, 200, 200)
            sp.graphics.endFill()

            var l:Label = new Label()
            l.text = p1.toString() + " -> " + p2.toString()
            l.setStyle("fontSize", 40);
            l.width = 200
            l.height = 200
            sp.addChild(l)

            sp.x = 100
            sp.y = 100
            contentUI.addChild(sp)
            TweenMax.delayedCall(2, contentUI.removeChild, [sp])
        })
    }

    private function onMonsterAdded(m:Monster):void {
        enemiesView.addChild(new MonsterView(m))
    }

    private function onSmokeAdded(x:int, y:int):void {
        var sp:SmokeSprite = new SmokeSprite(x * Consts.BLOCK_SIZE, y * Consts.BLOCK_SIZE)
        sp.x = x + Consts.BLOCK_SIZE_2 - Consts.SMOKE_WIDTH / 4;
        sp.y = y + Consts.BLOCK_SIZE_2 - Consts.SMOKE_HEIGHT / 4
        highestView.addChild(sp)
        sp.start()
    }

    private function mapWidth():Number {
        return game.mapManager.map.width * Consts.BLOCK_SIZE;
    }

    private function mapHeight():Number {
        return game.mapManager.map.height * Consts.BLOCK_SIZE
    }

    private function getHorScrollPos(x:Number):Number {
        if (x < VIEWPORT_WIDTH / 2)
            return 0;
        else if (x > mapWidth() - VIEWPORT_WIDTH / 2)
            return mapWidth() - VIEWPORT_WIDTH;
        return x - VIEWPORT_WIDTH / 2;
    }

    private function getVertScrollPos(y:Number):Number {
        if (y < VIEWPORT_HEIGHT / 2)
            return 0;
        else if (y > mapHeight() - VIEWPORT_HEIGHT / 2)
            return mapHeight() - VIEWPORT_HEIGHT;
        return y - VIEWPORT_HEIGHT / 2;
    }

    private function onPlayerCoordinatesChanged(x:Number, y:Number):void {
        horizontalScrollPosition = getHorScrollPos(x);
        verticalScrollPosition = getVertScrollPos(y)
        //trace(horizontalScrollPosition + "," + verticalScrollPosition);
    }


    public function draw():void {
        mapView.draw();
        explosionsView.draw();
        playerView.draw();
        for each (var obj:IDrawable in enemiesViews) {
            obj.draw();
        }
    }

    private function addedToStageHandler(event:Event):void {
        addElement(contentUI)
    }


    public function destroy():void {
    }
}
}