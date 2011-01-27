/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.interfaces {
import engine.bombss.interfaces.IBomb

public interface IBombsManager {

    function addBombAt(x:int, y:int, bomb:IBomb):void;

    function getBombAt(x:int, y:int):IBomb;

    /*
     * check if any bombs exploded within elapsed time
     * for singleplayer
     * */
    function checkBombs(elapsedMiliSecs:int):void;

    /*
     * manual explosion (bomb added to readyToExplode list)
     * for multiplayer
     * */
    function explodeBombAt(x:int, y:int, power:int = -1):void;

}
}