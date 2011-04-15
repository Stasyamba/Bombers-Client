/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
import components.common.bombers.BomberType
import components.common.worlds.locations.LocationType

import flash.utils.Dictionary

import greensock.events.LoaderEvent
import greensock.loading.ImageLoader
import greensock.loading.LoaderMax
import greensock.loading.LoaderStatus
import greensock.loading.SWFLoader
import greensock.loading.XMLLoader
import greensock.loading.core.LoaderCore
import greensock.loading.data.LoaderMaxVars
import greensock.loading.data.XMLLoaderVars

import org.osflash.signals.Signal

public class BombersContentLoader {

    private static const IMAGES_ADDRESS:String = "http://www.vensella.ru/vp/"

    private static var _filesXml:XML
    private static var _whatIsLoaded:Dictionary = new Dictionary()
    private static var _loadedImages:Dictionary = new Dictionary()


    public static var locationLoaded:Signal = new Signal(LocationType)
    public static var bomberLoaded:Signal = new Signal(BomberType)
    public static var commonLoaded:Signal = new Signal()
    public static var allBombersLoaded:Signal = new Signal()

    public static function loadImages():void {
        LoaderMax.activate([XMLLoader,SWFLoader,ImageLoader])
        var xmlLoader:XMLLoader = new XMLLoader(IMAGES_ADDRESS + "engine/files.xml",
                new XMLLoaderVars()
                        .onComplete(onXmlComplete)
                        .onError(onXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onXmlError(e:LoaderEvent):void {
        throw new Error("Error loading files.xml: " + e.text)
    }

    private static function commonHelper(subGroup:String, comQueue:LoaderMax):void {

        var comAddr:String = IMAGES_ADDRESS + _filesXml.common.@addr
        for each (var file:XML in (_filesXml.common as XMLList).descendants(subGroup).File) {

            var fname:String = file.@name
            var faddr:String = comAddr + subGroup + "/" + fname + file.@ext
            var fid:String = "common." + subGroup + "." + fname
            var ldr:LoaderCore = LoaderMax.parse(faddr,
                    new LoaderMaxVars()
                            .onError(function (e:LoaderEvent):void {
                        throw new Error("Error loading file " + e.target.name + ": " + e.text)
                    })
                            .name(fid))
            comQueue.append(ldr)
            trace("added common: " + fid)
            _loadedImages[fid] = new LoadedObject(fid, ldr)
        }
    }

    private static function onXmlComplete(e:LoaderEvent):void {

        _filesXml = (e.target as XMLLoader).content

        //common
        var comQueue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .onError(
                function (e:LoaderEvent):void {
                    throw new Error("Error loading common folder: " + e.text)
                })
                .onComplete(
                function (e:LoaderEvent):void {
                    whatIsLoaded["common"] = true
                    commonLoaded.dispatch()
                    trace("common loaded")
                })
                .name("common")
                )
        commonHelper("DO", comQueue)
        commonHelper("explosions", comQueue)
        commonHelper("healthBar", comQueue)
        commonHelper("other", comQueue)

        //bombers
        var bombersQueue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .onError(
                function (e:LoaderEvent):void {
                    throw new Error("Error loading bombers: " + e.text)
                })
                .onComplete(
                function (e:LoaderEvent):void {
                    whatIsLoaded["bombers"] = true
                    allBombersLoaded.dispatch()
                    trace("bombers loaded")
                })
                .name("bombers")
                )
        var bbsAddr:String = IMAGES_ADDRESS + _filesXml.bombers.@addr
        for each (var bomber:XML in _filesXml.bombers.Bomber) {
            var bId:String = bomber.@id
            var bArr:Array = new Array()
            for each (var file:XML in bomber.File) {
                var fname:String = file.@name
                var faddr:String = bbsAddr + bId + "/" + fname + file.@ext
                var fid:String = bId + "." + fname
                var ldr:LoaderCore = LoaderMax.parse(faddr,
                        new LoaderMaxVars()
                                .onError(
                                function (e:LoaderEvent):void {
                                    throw new Error("Error loading file " + e.target.name + ": " + e.text)
                                })
                                .name(fid))
                bArr.push(ldr)
                _loadedImages[fid] = new LoadedObject(fid, ldr)
            }
            var bLdr:LoaderCore = LoaderMax.parse(bArr,
                    new LoaderMaxVars()
                            .onError(
                            function (e:LoaderEvent):void {
                                throw new Error("Error loading bomber " + e.target.name + ": " + e.text)
                            })
                            .onComplete(
                            function (e:LoaderEvent):void {
                                whatIsLoaded[bId] = true
                                trace("bomber " + bId + " loaded")
                                bomberLoaded.dispatch(BomberType.byStringId(bId))
                            })
                            .name(bId))
            bombersQueue.append(bLdr)
        }

        //locations
        var locationsQueue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .onError(
                function (e:LoaderEvent):void {
                    throw new Error("Error loading locations: " + e.text)
                })
                .onComplete(
                function (e:LoaderEvent):void {
                    whatIsLoaded["locations"] = true
                    trace("locations loaded")
                })
                .name("locations")
                )
        var locsAddr:String = IMAGES_ADDRESS + _filesXml.locations.@addr

        for each (var location:XML in _filesXml.locations.Location) {
            var loc_id:String = location.@id
            var locAddr:String = locsAddr + loc_id + "/"
            var locLdr:LoaderMax = new LoaderMax(new LoaderMaxVars()
                    .onError(
                    function (e:LoaderEvent):void {
                        throw new Error("Error loading location " + e.target.name + ": " + e.text)
                    })
                    .onComplete(
                    function (e:LoaderEvent):void {
                        whatIsLoaded[e.target.name] = true
                        trace("location Loaded: " + e.target.name)
                        locationLoaded.dispatch(LocationType.byStringId(e.target.name))
                    })
                    .name(loc_id)
                    )
            for each (var fldr:XML in location.Folder) {
                var fldrName:String = fldr.@name
                var fldrLdr:LoaderMax = new LoaderMax(new LoaderMaxVars()
                        .onError(
                        function (e:LoaderEvent):void {
                            throw new Error("Error loading fldr " + e.target.name + ": " + e.text)
                        })
                        .onComplete(
                        function (e:LoaderEvent):void {
                            trace("fldr Loaded: " + e.target.name)
                        })
                        .name(loc_id + "." + fldrName)
                        )
                for each (var file:XML in fldr.File) {
                    var fname:String = file.@name
                    var faddr:String = locAddr + fldrName + "/" + fname + file.@ext
                    var fid:String = loc_id + "." + fldrName + "." + fname
                    var ldr:LoaderCore = LoaderMax.parse(faddr,
                            new LoaderMaxVars()
                                    .onError(
                                    function (e:LoaderEvent):void {
                                        throw new Error("Error loading file " + e.target.name + ": " + e.text)
                                    })
                                    .name(fid))
                    fldrLdr.append(ldr)
                    _loadedImages[fid] = new LoadedObject(fid, ldr)
                }

                locLdr.append(fldrLdr)
            }

            locationsQueue.append(locLdr)
        }

        //all
        var allLdr:LoaderCore = LoaderMax.parse([comQueue,bombersQueue,locationsQueue],
                new LoaderMaxVars()
                        .onError(
                        function (e:LoaderEvent):void {
                            throw new Error("Error loading all: " + e.text)
                        })
                        .onComplete(
                        function (e:LoaderEvent):void {
                            whatIsLoaded["all"] = true
                            trace("engine loaded")
                        })
                        .name("engine")
                )

        allLdr.load()
    }

    public static function get whatIsLoaded():Dictionary {
        return _whatIsLoaded
    }

    public static function get loadedImages():Dictionary {
        return _loadedImages
    }

    public static function addTask(taskSignal:Signal, array:Array):void {
        var taskObj:Object = new Object()
        for (var i:int = 0; i < array.length; i++) {
            var id:String = String(array[i])
            taskObj[id] = Context.imageService.isLoaded(id)
            if (!taskObj[id]) {
                var ldr:LoaderCore = LoaderMax.getLoader(id)
                if (ldr.status == LoaderStatus.COMPLETED) //'completed' already fired but not handled
                    taskObj[id] = true
                else
                    ldr.addEventListener(LoaderEvent.COMPLETE, function (e:LoaderEvent):void {
                        taskObj[e.target.name] = true
                        checkTask(taskSignal, taskObj)
                    })
            }
        }
        checkTask(taskSignal, taskObj)
    }

    private static function checkTask(taskSignal:Signal, taskObj:Object):void {
        for each(var loaded:Boolean in taskObj) {
            if (!loaded)
                return
        }
        taskSignal.dispatch()
    }

    //Quests

    private static var _questsNames:Array = ["q00_00"]
    private static const QUESTS_ADDRESS:String = "engine/data/quests/"

    private static var _areQuestsLoaded:Boolean = false
    private static var xmls:Array = new Array()

    public static var questsLoaded:Signal = new Signal()

    public static function get areQuestsLoaded():Boolean {
        return _areQuestsLoaded
    }

    public static function loadQuests():void {
        var queue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .name("quests")
                .onComplete((
                function(e:LoaderEvent) {
                    trace("quests loaded")
                    _areQuestsLoaded = true
                    questsLoaded.dispatch()
                }))
                .onError(
                function(e:LoaderEvent) {
                    throw new Error("Error loading quests: " + e.target.text)
                })
                )
        for each (var name:String in _questsNames) {
            queue.append(new XMLLoader(name + ".xml", new XMLLoaderVars()
                    .name(name)
                    .onError(
                    function(e:LoaderEvent) {
                        throw new Error("Error loading quest " + e.target.name + ": " + e.target.text)
                    })
                    .onComplete(
                    function(e:LoaderEvent) {
                        trace("quest " + name + " loaded")
                        xmls[e.target.name] = e.target.content
                    })))
        }
        queue.prependURLs(QUESTS_ADDRESS)
        queue.load()
    }

    public static function questXML(questId:String):XML {
        return xmls[questId]
    }

    public static function get questsNames():Array {
        return _questsNames
    }


}
}
