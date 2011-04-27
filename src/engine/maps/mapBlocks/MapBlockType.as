/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks {
public class MapBlockType {

    public static const DEFAULT_GRAPHICS_NAME:String = "_"

    public static const NULL:MapBlockType = new MapBlockType("NULL",false,null);
    public static const FREE:MapBlockType = new MapBlockType("FREE",false,null);
    public static const BOX:MapBlockType = new MapBlockType("BOX",true,DEFAULT_GRAPHICS_NAME);
    public static const WALL:MapBlockType = new MapBlockType("WALL",true,DEFAULT_GRAPHICS_NAME);
    public static const DEATH_WALL:MapBlockType = new MapBlockType("DEATH_WALL",true,DEFAULT_GRAPHICS_NAME,"wall");
    public static const FRAGILE_WALL:MapBlockType = new MapBlockType("FRAGILE_WALL",true,DEFAULT_GRAPHICS_NAME);
    public static const UNDER_BIG_OBJECT:MapBlockType = new MapBlockType("UNDER_BIG_OBJECT",false,null);
    public static const FIRE:MapBlockType = new MapBlockType("FIRE",true,"common.map.fire1")
    public static const MAGNET:MapBlockType = new MapBlockType("MAGNET",true,"common.map.magnet1")
    public static const ICE:MapBlockType = new MapBlockType("ICE",true,"common.map.ice1")
    public static const GLUE:MapBlockType = new MapBlockType("GLUE",true,"common.map.glue1")
    public static const ELECTRO_HOR:MapBlockType = new MapBlockType("ELECTRO_HOR",true,"common.map.electro-hor1")
    public static const ELECTRO_VERT:MapBlockType = new MapBlockType("ELECTRO_VERT",true,"common.map.electro-vert1")

    private static const f:uint = 0x66;
    private static const b:uint = 0x62;
    private static const w:uint = 0x77;
    private static const d:uint = 0x64;
    private static const u:uint = 0x75;

    private static const F:uint = 0x46;
    private static const M:uint = 0x4D;
    private static const I:uint = 0x49;
    private static const G:uint = 0x47;
    private static const EH:uint = 0x2D;  //-
    private static const EV:uint = 0x7C;  //|

    private var _key:String;
    private var _draws:Boolean
    private var _graphicsName:String
    private var _nameAs:String

    public function MapBlockType(value:String,draws:Boolean,graphicsName:String,drawAs:String = null) {
        _key = value;
        _draws = draws
        _graphicsName = graphicsName
        _nameAs = drawAs
    }

    public function get key():String {
        return _key;
    }

    public static function byKey(key:String):MapBlockType {
        switch (key) {
            case "NULL":return NULL;
            case "FREE":return FREE;
            case "BOX":return BOX;
            case "WALL":return WALL;
            case "DEATH_WALL":return DEATH_WALL;
            case "FRAGILE_WALL":return FRAGILE_WALL;
            case "UNDER_BIG_OBJECT":return UNDER_BIG_OBJECT;
            case "FIRE":return FIRE;
            case "MAGNET":return MAGNET;
            case "ICE":return ICE;
            case "GLUE":return GLUE;
            case "ELECTRO_HOR":return ELECTRO_HOR;
            case "ELECTRO_VERT":return ELECTRO_VERT;
        }
        throw new ArgumentError("invalid key value " + key)
    }

    public static function fromChar(ch:uint):MapBlockType {
        switch (ch) {
            case F: return FIRE;
            case M: return MAGNET;
            case I: return ICE;
            case G: return GLUE;
            case EH: return ELECTRO_HOR;
            case EV: return ELECTRO_VERT;
            case f: return FREE;
            case w: return WALL;
            case b: return BOX;
            case d: return FRAGILE_WALL;
            case u: return UNDER_BIG_OBJECT;
        }
        throw new ArgumentError("Invalid block type char");
    }

    public function get draws():Boolean {
        return _draws
    }

    public function get graphicsName():String {
        return _graphicsName
    }

    public function get nameAs():String {
        return _nameAs
    }
}
}