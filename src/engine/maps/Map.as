/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.maps.bigObjects.ActivatedBigObject
import engine.maps.bigObjects.BigObjectActivator
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.BigObjectLayer
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.shadows.ShadowObject
import engine.shadows.ShadowShape

import mx.controls.Alert

import org.osflash.signals.Signal

public class Map extends MapBase implements IMap {

    //blockBuilder is injected via mapBuilder
    public function Map(xml:XML, blockBuilder:MapBlockBuilder) {
        this.blockBuilder = blockBuilder;
        fill(xml);
    }

    public function fill(xml:XML):void {

        _width = xml.size.@width;
        _height = xml.size.@height;

        _blocks = new Vector.<IMapBlock>(_width * _height, true);

        var y:int = 0;
        for each (var rowXml:XML in xml.rows.Row) {
            var rowStr:String = rowXml.@val;
            for (var x:int = 0; x < rowStr.length; x++) {
                try {
                    _blocks[index(x, y)] = blockBuilder.make(x, y, MapBlockType.fromChar(rowStr.charCodeAt(x)));
                    _blocks[index(x, y)].destroyed.add(function(x:int, y:int, type:MapBlockType):void {
                        _blockDestroyed.dispatch(x, y, type);
                    })
                } catch(er:ArgumentError) {
                    Alert.show("String contains bad symbol " + rowStr.charCodeAt(x));
                }
            }
            y++;
        }

        //bigObjects
        for each (var bObj:XML in xml.bigObjects.BigObject) {
            var bo:BigObjectBase;
            switch (String(bObj.@t)) {
                case "activator":
                    bo = new BigObjectActivator(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "activated":
                    bo = new ActivatedBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "simple":
                    bo = new SimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life)
                    break
            }
            _bigObjects[bo.id] = bo
            switch (bo.layer) {
                case BigObjectLayer.DECORATION:
                    decorations.push(bo)
                    break
                case BigObjectLayer.HIGHER:
                    higherBigObjects.push(bo);
                    break
                case BigObjectLayer.LOWER:
                    lowerBigObjects.push(bo);
                    break
                default:
                    throw new Error("impossible case")
            }
        }
        //resolve activators links
        for each (bObj in xml.bigObjects.BigObject) {
            var bo:BigObjectBase = getBO(bObj.@id)
            if (bo is BigObjectActivator) {
                var target:ActivatedBigObject = getBO(bObj.@target) as ActivatedBigObject
                if (target == null) {
                    throw new Error("couldn't find target with id = " + bObj.@target)
                }
                (bo as BigObjectActivator).setTarget(target)
            }
        }
        for each (var spawn:XML in xml.spawns.Spawn) {
            _spawns.push({x:spawn.@x,y:spawn.@y})
        }

        //shadows
        for each (var s:XML in xml.shadows.Shadow) {
            _shadows.push(new ShadowObject(s.@x, s.@y, s.@width, s.@height, ShadowShape.fromString(s.@shape)))
        }
    }


}
}