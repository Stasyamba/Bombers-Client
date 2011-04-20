/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.model.explosionss.ExplosionType

public class ExplosionPointLayerObject {
    public var owner:IBomber
    public var explosionType:ExplosionType

    public function ExplosionPointLayerObject(owner:IBomber, explosionType:ExplosionType) {
        this.owner = owner
        this.explosionType = explosionType
    }
}
}
