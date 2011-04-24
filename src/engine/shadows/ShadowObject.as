/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.shadows {
public class ShadowObject {

    public var x:int
    public var y:int
    public var width:int
    public var height:int
    public var shape:ShadowShape


    public function ShadowObject(x:int, y:int, width:int, height:int, shape:ShadowShape) {
        this.x = x
        this.y = y
        this.width = width
        this.height = height
        this.shape = shape
    }
}
}
