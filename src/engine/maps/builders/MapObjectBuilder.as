/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.builders {
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapObject
import engine.maps.interfaces.IMapObjectType
import engine.maps.mapObjects.MapObjectType
import engine.maps.mapObjects.NullMapObject
import engine.maps.mapObjects.bonuses.BonusAddBomb
import engine.maps.mapObjects.bonuses.BonusAddBombPower
import engine.maps.mapObjects.bonuses.BonusAddSpeed
import engine.maps.mapObjects.bonuses.BonusHeal
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.maps.mapObjects.mines.RegularMine

public class MapObjectBuilder {

    public function make(objType:IMapObjectType, block:IMapBlock):IMapObject {
        switch (objType) {
            case MapObjectType.NULL:
                return NullMapObject.getInstance();
            //bonuses
            case BonusType.ADD_BOMB:
                return new BonusAddBomb(block)
            case BonusType.ADD_BOMB_POWER:
                return new BonusAddBombPower(block)
            case BonusType.ADD_SPEED:
                return new BonusAddSpeed(block);
            case BonusType.HEAL:
                return new BonusHeal(block);
            //mines
            case MineType.REGULAR:
                return new RegularMine(block);
        }
        throw new Error("NotImplemented");
    }
}
}