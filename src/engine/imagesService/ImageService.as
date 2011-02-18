/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.imagesService {
import engine.bombers.skin.BomberSkin
import engine.bombss.BombType
import engine.data.Consts
import engine.data.Explosions
import engine.data.location1.bombs.Bombs
import engine.data.location1.health_bar.HealthBar
import engine.data.location1.mapObjects.BigObjectsSkins
import engine.data.location1.mapObjects.bonuses.Bonuses
import engine.data.location1.mapObjects.mines.Mines
import engine.data.location1.maps.MapBlocks
import engine.data.location1.skins.BomberSkins
import engine.explosionss.ExplosionPointType
import engine.maps.interfaces.IDynObjectType
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.model.explosionss.ExplosionType
import engine.playerColors.PlayerColor

import flash.display.BitmapData
import flash.geom.Point
import flash.geom.Rectangle

public class ImageService {

    public function ImageService() {
    }

    public function getHealthBar(lifePercent:Number):BitmapData {
        var side:BitmapData,center:BitmapData;
        var b:BitmapData = new BitmapData(Consts.HEALTH_BAR_WIDTH, Consts.HEALTH_BAR_HEIGHT, true, 0);
        if (lifePercent > 0.9) {
            side = HealthBar.GREEN_SIDE;
            center = HealthBar.GREEN_CENTER;
        } else if (lifePercent > 0.4) {
            side = HealthBar.YELLOW_SIDE;
            center = HealthBar.YELLOW_CENTER;
        } else {
            side = HealthBar.RED_SIDE;
            center = HealthBar.RED_CENTER;
        }
        var length:int = int(lifePercent * Consts.HEALTH_BAR_WIDTH);
        b.copyPixels(side, new Rectangle(0, 0, 1, 5), new Point(0, 0));
        for (var i:int = 1; i < length - 1; i++) {
            b.copyPixels(center, new Rectangle(0, 0, 1, 5), new Point(i, 0));
        }
        b.copyPixels(side, new Rectangle(0, 0, 1, 5), new Point(length - 1, 0));
        return b;
    }

    public function getBomberSkin(skinName:String):BomberSkin {
        return BomberSkins[skinName];
    }

    public function getMapBlock(blockType:MapBlockType, location:String = ""):BitmapData {

        return MapBlocks[blockType.key];
    }

    public function getBomb(type:BombType, color:PlayerColor):BitmapData {
        var b:BitmapData = new BitmapData(Consts.BLOCK_SIZE, Consts.BLOCK_SIZE, true, 0);
        var bImage:BitmapData = Bombs[type.key];
        b.copyPixels(bImage, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0));
        if (type.needGlow) {
            b.copyPixels(color.bombGlow, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0), null, null, true);
            b.copyPixels(color.bombGlow, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0), null, null, true);
        }
        return b;
    }

    public function getExplosion(explType:ExplosionType, explPointType:ExplosionPointType):BitmapData {
        switch (explType) {
            case ExplosionType.REGULAR:
            case ExplosionType.ATOM:
            case ExplosionType.DYNAMITE:
                return Explosions[explPointType.value]
        }
        return null;
    }

    public function getObject(type:IDynObjectType):BitmapData {
        if (type is BonusType) {
            return Bonuses[type.key];
        } else if (type is MineType)
            return Mines[type.key]
        return null;
    }

    public function getExplosionPrint(explType:ExplosionType):BitmapData {
        return Explosions['PRINT'];
    }

    public function getDieExplosion(index:int):BitmapData {
        if (index < 0 || index > 2)
            throw new ArgumentError("wrong die explosion index");
        return Explosions['DIE' + index]
    }

    public function getBigObject(skin:String):BitmapData {
        return BigObjectsSkins[skin];
    }
}
}