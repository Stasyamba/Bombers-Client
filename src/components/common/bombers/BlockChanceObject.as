/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package components.common.bombers {
public class BlockChanceObject {
    public var bomberType:BomberType
    public var blockChance:Number

    public function BlockChanceObject(bomberType:BomberType, blockChance:Number) {
        this.bomberType = bomberType
        this.blockChance = blockChance
    }
}
}
