/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.skin {
import components.common.bombers.BomberType

public class BomberSkin {

    public var name:String
    public var skinElements:Object;
    public var colors:Object;

    public function BomberSkin(name:String, skinElements:Object, colors:Object) {
        this.name = name;
        this.skinElements = skinElements;
        this.colors = colors;
    }

}
}