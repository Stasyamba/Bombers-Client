/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.resources {
import mx.collections.ArrayList

public class Price {

    private var resources:ArrayList = new ArrayList();

    public function Price(...rest) {
        for each (var resAmount:ResourceAmount in rest) {
            for each (var res:ResourceAmount in resources.source) {
                if (res.resType == resAmount.resType)
                    throw new ArgumentError("multiple amounts of same type are not allowed in price object");
            }
            resources.addItem(resAmount);
        }
    }

    public function getPart(resType:ResourceType):ResourceAmount {
        for each (var resAmount:ResourceAmount in resources.source) {
            if (resAmount.resType == resType)
                return resAmount;
        }
        return new ResourceAmount(0, resType);
    }
}
}
