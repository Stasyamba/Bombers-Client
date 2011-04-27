/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
import components.common.bombers.BomberType
import components.common.items.ItemType
import components.common.worlds.locations.LocationType

import engine.games.quest.monsters.MonsterType

import flash.utils.Dictionary

import greensock.events.LoaderEvent
import greensock.loading.LoaderMax
import greensock.loading.LoaderStatus
import greensock.loading.XMLLoader
import greensock.loading.core.LoaderCore
import greensock.loading.data.LoaderMaxVars
import greensock.loading.data.XMLLoaderVars

import org.osflash.signals.Signal

public class BombersContentLoader {

    private static const IMAGES_ADDRESS:String = "http://www.vensella.ru/vp/images/"
    private static const QUESTS_ADDRESS:String = "http://www.vensella.ru/vp/quests/"
    private static const MONSTERS_ADDRESS:String = "http://www.vensella.ru/vp/monsters/monsters.xml"
    private static const BOMBERS_ADDRESS:String = "http://www.vensella.ru/vp/bombers/bombers.xml"

    private static var _filesXml:XML
    private static var _whatIsLoaded:Dictionary = new Dictionary()
    private static var _loadedGraphics:Dictionary = new Dictionary()
    private static var _monstersXml:XML
    private static var _bombersXml:XML

    public static var locationGraphicsLoaded:Signal = new Signal(LocationType)
    public static var bomberGraphicsLoaded:Signal = new Signal(BomberType)
    public static var commonGraphicsLoaded:Signal = new Signal()
    public static var allBombersGraphicsLoaded:Signal = new Signal()


    public static var readyToUseAppView:Signal = new Signal()

    // bombers
    public static var bomberTypesLoaded:Signal = new Signal()

    private static var _areBomberTypesLoaded:Boolean

    public static function loadBombers():void {
        var xmlLoader:XMLLoader = new XMLLoader(BOMBERS_ADDRESS,
                new XMLLoaderVars()
                        .onComplete(onBombersXmlComplete)
                        .onError(onBombersXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onBombersXmlError(e:LoaderEvent):void {
        throw new Error("error loading bombers description: " + e.text)
    }

    private static function onBombersXmlComplete(e:LoaderEvent):void {
        _bombersXml = (e.target as XMLLoader).content
        for each (var b:XML in _bombersXml.B) {
            //todo: access rules parsing
            var accessRules:Array = new Array()
            var bt:BomberType = new BomberType(b.@id, b.@name, ItemType.byValue(b.@bombId), b.@bombCount, b.@bombPower, b.@speed, b.@life, b.@crit, b.@block, b.@immortalTime, b.@graphicsId, accessRules, b.@description, b.@bigImageURL)
            BomberType.add(bt)
            Context.Model.bomberManager.addBomber(bt)
        }
        _areBomberTypesLoaded = true
        bomberTypesLoaded.dispatch()
        if (_areQuestsLoaded)
            readyToUseAppView.dispatch()
    }

    // Quests

    private static var _questsNames:Array = ["q00_00"]

    private static var _areQuestsLoaded:Boolean = false
    private static var _questXmls:Array = new Array()

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
                    if (_areBomberTypesLoaded)
                        readyToUseAppView.dispatch()
                }))
                .onError(
                function(e:LoaderEvent) {
                    throw new Error("Error loading quests: " + e.target.text)
                })
                )
        for each (var name:String in _questsNames) {
            queue.append(new XMLLoader(name + ".xml", new XMLLoaderVars()
                    .name(name)
                    .noCache(true)
                    .onError(
                    function(e:LoaderEvent) {
                        throw new Error("Error loading quest " + e.target.name + ": " + e.target.text)
                    })
                    .onComplete(
                    function(e:LoaderEvent) {
                        trace("quest " + name + " loaded")
                        _questXmls[e.target.name] = e.target.content
                    })))
        }
        queue.prependURLs(QUESTS_ADDRESS)
        queue.load()
    }

    public static function questXML(questId:String):XML {
        return _questXmls[questId]
    }

    public static function get questsNames():Array {
        return _questsNames
    }

    // monsters
    public static function loadMonsters():void {
        var xmlLoader:XMLLoader = new XMLLoader(MONSTERS_ADDRESS,
                new XMLLoaderVars()
                        .onComplete(onMonstersXmlComplete)
                        .onError(onMonstersXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onMonstersXmlError(e:LoaderEvent):void {
        throw new Error("error loading monsters description: " + e.text)
    }

    private static function onMonstersXmlComplete(e:LoaderEvent):void {
        _monstersXml = (e.target as XMLLoader).content
        for each (var m:XML in _monstersXml.M) {
            MonsterType.add(new MonsterType(m.@id, m.@graphicsId, m.@speed, m.@life, m.@immortalTime, m.@name))
        }
    }

    // graphics
    public static function loadGraphics():void {
        var xmlLoader:XMLLoader = new XMLLoader(IMAGES_ADDRESS + "engine/files.xml",
                new XMLLoaderVars()
                        .onComplete(onGraphicsXmlComplete)
                        .onError(onGraphicsXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onGraphicsXmlError(e:LoaderEvent):void {
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
            _loadedGraphics[fid] = new LoadedObject(fid, ldr)
        }
    }

    private static function onGraphicsXmlComplete(e:LoaderEvent):void {

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
                    commonGraphicsLoaded.dispatch()
                    trace("common loaded")
                })
                .name("common")
                )
        commonHelper("DO", comQueue)
        commonHelper("map", comQueue)
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
                    allBombersGraphicsLoaded.dispatch()
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
                _loadedGraphics[fid] = new LoadedObject(fid, ldr)
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
                                bomberGraphicsLoaded.dispatch(BomberType.byStringId(bId))
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
                        locationGraphicsLoaded.dispatch(LocationType.byStringId(e.target.name))
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
                    _loadedGraphics[fid] = new LoadedObject(fid, ldr)
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

    public static function get loadedGraphics():Dictionary {
        return _loadedGraphics
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


}
}
