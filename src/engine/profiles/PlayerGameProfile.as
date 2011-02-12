/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.profiles {
import components.common.bombers.BomberType

public class PlayerGameProfile {
    public var playerId:int
    public var bomberType:BomberType
    public var x:int
    public var y:int
    public var auras:Array

    public function PlayerGameProfile(playerId:int, bomberType:BomberType, x:int, y:int, auras:Array) {
        this.playerId = playerId
        this.bomberType = bomberType
        this.x = x
        this.y = y
        this.auras = auras
    }
}
}
