/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers {
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.data.Consts
import engine.explosionss.ExplosionPoint
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock

public class PlayerManagerBase {
    public function PlayerManagerBase() {
    }

    protected var _me:IPlayerBomber;

    public function setPlayer(player:IPlayerBomber):void {
        _me = player;
    }

    public function movePlayer(elapsedMilliSecs:int):void {
        me.move(elapsedMilliSecs);
    }

    //todo: later maybe let explosion manager explode players, here just return bool


    public function get me():IPlayerBomber {
        return _me;
    }

    public function get mySlot():int {
        return _me.slot;
    }




    public function killMe():void {
        me.kill();
    }

    public function isItMe(bomber:IBomber):Boolean {
        return bomber == _me
    }
}
}