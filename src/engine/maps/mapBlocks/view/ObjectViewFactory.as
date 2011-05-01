/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.bombss.BombType;
import engine.bombss.view.BombView;
import engine.maps.interfaces.IDynObject;
import engine.maps.mapObjects.bonuses.BonusType;
import engine.maps.mapObjects.mines.MineType;
import engine.maps.mapObjects.special.SpecialObject;
import engine.maps.mapObjects.special.SpecialObjectType;

import flash.display.Sprite;

public class ObjectViewFactory {
    public function ObjectViewFactory() {
    }

    public static function make(object:IDynObject, baseView:Sprite):DestroyableSprite {
        if (object.type is BonusType)
            return new BonusView(object.block, baseView);
        else if (object.type is MineType)
            return new MineView(object.block, baseView)
        else if (object.type is BombType)
            return new BombView(object.block, baseView)
        else if (object.type is SpecialObjectType)
            return new SpecialObjectView(object.block, baseView)
        throw new ArgumentError("Unknown object type " + object.type.key);
    }
}
}
