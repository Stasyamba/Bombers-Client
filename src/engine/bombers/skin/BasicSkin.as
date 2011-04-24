/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.skin {
public class BasicSkin {

    public var name:String
    public var skinElements:Object;
    public var colors:Object;

    public function BasicSkin(name:String, skinElements:Object, colors:Object) {
        this.name = name;
        this.skinElements = skinElements;
        this.colors = colors;
    }

}
}