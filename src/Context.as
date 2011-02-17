package {
import api.vkontakte.business.*

import appmodel.ApplicationModel

import components.common.resources.resourcemarket.ResourceMarket

import engine.games.IGame
import engine.imagesService.ImageService
import engine.model.GameModel
import engine.model.gameServer.GameServer

public final class Context extends VyanaContext {

    function Context() {
        services = new VkontakteServices();
    }

    private var _gameModel:GameModel;
    private var _imageService:ImageService;
    private var _gameServer:GameServer;
    private var _resourceMarket:ResourceMarket

    public var game:IGame;

    public static function wrongJSONToArray(source:String):Array {
        var tmpArr:Array = source.split("},{");
        if (tmpArr.length == 1) {
            return tmpArr;
        }

        var sideFlag:Boolean = false;
        for (var i:int = 0; i <= tmpArr.length - 1; i++) {
            if (!sideFlag)
                tmpArr[i] += "}";
            else
                tmpArr[i] = "{" + tmpArr[i];

            sideFlag = !sideFlag;
        }

        return tmpArr;
    }

    public static function isSettingsIncludeArr(settings:int, arrSettings:Array):Boolean {
        var res:Boolean = false;

        var arr:Array = [1,2,4,8,16,32,64,128,256,512,1024,2048];
        var tmpArr:Array = new Array();


        for each(var n:int in arrSettings) {
            tmpArr.push(n);
        }

        for (var i:int = arr.length - 1; i >= 0; i--) {

            if (settings - arr[i] >= 0) {
                settings -= arr[i];

                for (var j:int = 0; j <= tmpArr.length - 1; j++) {
                    if (tmpArr[j] == arr[i]) {
                        tmpArr[j] = 0;
                        break;
                    }
                }
            }

        }

        var summ:int = 0;
        for (var k:int = 0; k <= tmpArr.length - 1; k++) {
            summ += tmpArr[k];
        }

        if (summ == 0)
            res = true;

        return res;
    }


    public static function getInstance():Context {
        return VyanaContext.getInstance() as Context;
    }

    public static function get Model():ApplicationModel {
        if (!Context.getInstance().model) {
            Context.getInstance().model = new ApplicationModel();
        }
        return Context.getInstance().model as ApplicationModel;
    }

    public static function get gameModel():GameModel {
        if (!Context.getInstance()._gameModel) {
            Context.getInstance()._gameModel = new GameModel();
        }
        return Context.getInstance()._gameModel;
    }

    public static function get imageService():ImageService {
        if (!Context.getInstance()._imageService) {
            Context.getInstance()._imageService = new ImageService();
        }
        return Context.getInstance()._imageService;
    }

    public static function get gameServer():GameServer {
        if (!Context.getInstance()._gameServer) {
            Context.getInstance()._gameServer = new GameServer();
        }
        return Context.getInstance()._gameServer;
    }

    public static function get game():IGame {
        return Context.getInstance().game;
    }

    public static function set game(value:IGame):void {
        Context.getInstance().game = value;
    }

    public static function get resourceMarket():ResourceMarket {
        if (!Context.getInstance()._resourceMarket) {
            Context.getInstance()._resourceMarket = new ResourceMarket()
        }
        return Context.getInstance()._resourceMarket;
    }

}
}