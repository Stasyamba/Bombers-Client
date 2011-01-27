/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.maps.interfaces.IMapObject
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType

import flash.display.Sprite

public class ObjectViewFactory {
    public function ObjectViewFactory() {
    }

    public static function make(object:IMapObject, baseView:Sprite):DestroyableSprite {
        if (object.type is BonusType)
            return new BonusView(object.block, baseView);
        else if (object.type is MineType)
            return new MineView(object.block, baseView)

        throw new ArgumentError("Unknown object type " + object.type.key);
    }
}
}
