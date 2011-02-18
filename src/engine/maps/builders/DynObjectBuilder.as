/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.builders {
import engine.bombers.interfaces.IBomber
import engine.bombss.AtomBomb
import engine.bombss.BombType
import engine.bombss.BoxBomb
import engine.bombss.DynamiteBomb
import engine.bombss.RegularBomb
import engine.explosionss.ExplosionsBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.NullDynObject
import engine.maps.mapObjects.bonuses.BonusAddBomb
import engine.maps.mapObjects.bonuses.BonusAddBombPower
import engine.maps.mapObjects.bonuses.BonusAddSpeed
import engine.maps.mapObjects.bonuses.BonusHeal
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.maps.mapObjects.mines.RegularMine

public class DynObjectBuilder {

    private var explosionsBuilder:ExplosionsBuilder

    public function make(objType:IDynObjectType, block:IMapBlock, owner:IBomber = null):IDynObject {
        switch (objType) {
            case DynObjectType.NULL:
                return NullDynObject.getInstance();
            //bombs
            case BombType.REGULAR:
                return new RegularBomb(explosionsBuilder, block, owner)
            case BombType.ATOM:
                return new AtomBomb(explosionsBuilder, block, owner)
            case BombType.BOX:
                return new BoxBomb(explosionsBuilder, block, owner)
            case BombType.DYNAMITE:
                return new DynamiteBomb(explosionsBuilder, block, owner)
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
                return new RegularMine(block, owner);
        }
        throw new Error("NotImplemented");
    }

    public function setExplosionsBuilder(explosionsBuilder:ExplosionsBuilder):void {
        this.explosionsBuilder = explosionsBuilder
    }
}
}