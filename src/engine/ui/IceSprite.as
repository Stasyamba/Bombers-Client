/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.ui {
import engine.data.Consts

import flash.display.Sprite

public class IceSprite extends Sprite {
    public function IceSprite() {
        super()
        graphics.beginFill(0xFF, 0.8)
        graphics.drawCircle(Consts.BLOCK_SIZE_2, Consts.BLOCK_SIZE_2, Consts.BLOCK_SIZE_2)
        graphics.endFill()
    }
}
}
