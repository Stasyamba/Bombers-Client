/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.data.location1.skins {
import engine.bombers.skin.BomberSkin
import engine.bombers.skin.SkinElement

import flash.display.Bitmap
import flash.utils.ByteArray

public class BomberSkins {

    //---FURY_JOE
    [Embed(source="../images/skins/FURY_JOE_left.png")]
    public static const FURY_JOE_left:Class;
    [Embed(source="../images/skins/FURY_JOE_right.png")]
    public static const FURY_JOE_right:Class;
    [Embed(source="../images/skins/FURY_JOE_up.png")]
    public static const FURY_JOE_up:Class;
    [Embed(source="../images/skins/FURY_JOE_down.png")]
    public static const FURY_JOE_down:Class;
    [Embed(source="../images/skins/FURY_JOE_down.png")]
    public static const FURY_JOE_none:Class;

    [Embed(source="../images/skins/FURY_JOE_left_mask.png")]
    public static const FURY_JOE_left_mask:Class;
    [Embed(source="../images/skins/FURY_JOE_right_mask.png")]
    public static const FURY_JOE_right_mask:Class;
    [Embed(source="../images/skins/FURY_JOE_up_mask.png")]
    public static const FURY_JOE_up_mask:Class;
    [Embed(source="../images/skins/FURY_JOE_down_mask.png")]
    public static const FURY_JOE_down_mask:Class;
    [Embed(source="../images/skins/FURY_JOE_down_mask.png")]
    public static const FURY_JOE_none_mask:Class;

    private static var FURY_JOE_skin:BomberSkin;

    public static function get FURY_JOE():BomberSkin {
        if (FURY_JOE_skin == null) {
            FURY_JOE_skin = makeSkin("FURY_JOE");
        }
        return FURY_JOE_skin;
    }

    //---R2D3
    [Embed(source="../images/skins/R2D3_left.png")]
    public static const R2D3_left:Class;
    [Embed(source="../images/skins/R2D3_right.png")]
    public static const R2D3_right:Class;
    [Embed(source="../images/skins/R2D3_up.png")]
    public static const R2D3_up:Class;
    [Embed(source="../images/skins/R2D3_down.png")]
    public static const R2D3_down:Class;
    [Embed(source="../images/skins/R2D3_down.png")]
    public static const R2D3_none:Class;

    [Embed(source="../images/skins/R2D3_left_mask.png")]
    public static const R2D3_left_mask:Class;
    [Embed(source="../images/skins/R2D3_right_mask.png")]
    public static const R2D3_right_mask:Class;
    [Embed(source="../images/skins/R2D3_up_mask.png")]
    public static const R2D3_up_mask:Class;
    [Embed(source="../images/skins/R2D3_down_mask.png")]
    public static const R2D3_down_mask:Class;
    [Embed(source="../images/skins/R2D3_down_mask.png")]
    public static const R2D3_none_mask:Class;

    private static var R2D3_skin:BomberSkin;

    public static function get R2D3():BomberSkin {
        if (R2D3_skin == null) {
            R2D3_skin = makeSkin("R2D3");
        }
        return R2D3_skin;
    }

    // ---  utils
    [Embed(source="BomberSkins.xml",mimeType="application/octet-stream")]
    private static const xmlClass:Class;
    private static var _xml:XML;
    private static function get xml():XML {
        if (_xml == null) {
            var file:ByteArray = new xmlClass();
            var str:String = file.readUTFBytes(file.length);
            _xml = new XML(str);
        }
        return _xml;
    }

    private static function makeSkin(name:String):BomberSkin {
        var skinXml:XMLList = xml.child(name);
        var colorsObject:Object = new Object();
        var skinElements:Object = new Object();

        for each (var skinColor:XML in skinXml.colors.SkinColor) {
            var pColor:String = skinColor.@val;
            colorsObject[pColor] = {color:uint(skinColor.color.@val),blendMode:skinColor.blendMode.@val,opacity:Number(skinColor.opacity.@val)}
        }
        skinElements.left = new SkinElement(new BomberSkins[name + "_left"]() as Bitmap, new BomberSkins[name + "_left_mask"]() as Bitmap)
        skinElements.right = new SkinElement(new BomberSkins[name + "_right"]() as Bitmap, new BomberSkins[name + "_right_mask"]() as Bitmap)
        skinElements.up = new SkinElement(new BomberSkins[name + "_up"]() as Bitmap, new BomberSkins[name + "_up_mask"]() as Bitmap)
        skinElements.down = new SkinElement(new BomberSkins[name + "_down"]() as Bitmap, new BomberSkins[name + "_down_mask"]() as Bitmap)
        skinElements.none = new SkinElement(new BomberSkins[name + "_none"]() as Bitmap, new BomberSkins[name + "_none_mask"]() as Bitmap)

        return new BomberSkin(name, skinElements, colorsObject);
    }
}
}