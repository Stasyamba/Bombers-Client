package {
import components.common.game.requesttogame.RequestGameObject
import components.common.profiles.ISocialProfile
import components.common.profiles.SocialProfile
import components.common.utils.enviroment.vkontakte.ApiResult
import components.common.utils.enviroment.vkontakte.FlashVars

import engine.games.GameType
import engine.profiles.GameProfile

[Bindable]
public class Settings 
{

    public var flashVars:FlashVars = new FlashVars();
    public var apiResult:ApiResult;

    public var gameProfile:GameProfile = new GameProfile();
    public var socialProfile:ISocialProfile;
    public var currentSocialWeb:int = SocialProfile.VKONTAKTE;

    private var _requestToGames:Array = new Array(); // type = [RequestGameObject, ...]


    public function get requestToGames():Array {
        return _requestToGames;
    }

    public function cleanOldRequests():void {
        var currentTime:int = (new Date()).milliseconds;
        var tmp:Array = new Array();

        for (var i:int = 0; i <= _requestToGames.length - 2; i++) // -2 -> each element exept last
        {
            if (currentTime - _requestToGames[i].sendTime < 300000) {
                tmp.push(_requestToGames[i]);
            }
        }

        _requestToGames = tmp;
    }

    public function addRequest(rgo:RequestGameObject):void {
        var isFinded:Boolean = false;
        var tmp:Array = new Array();

        for each(var r:RequestGameObject in _requestToGames) {
            if (r.isEqual(rgo)) {
                isFinded = true;
            } else {
                tmp.push(r);
            }
        }

        if (isFinded) {
            _requestToGames = tmp;
        }

        _requestToGames.push(rgo);
    }

    /**
     * return index element that was delete
     * **/
    public function deleteRequest(rgo:RequestGameObject):int {
        var isFinded:Boolean = false;
        var tmp:Array = new Array();
        var index:int = 0;

        for each(var r:RequestGameObject in _requestToGames) {
            if (!isFinded) {
                index++;
            }

            if (r == rgo) {
                isFinded = true;
            } else {
                tmp.push(r);
            }
        }

        if (isFinded) {
            _requestToGames = tmp;
        } else {
            index = -1;
        }

        return index;
    }


    // immitation
    public function fillRequestsTest():void {
        var profile:GameProfile = new GameProfile();
        profile.id = 0;
        profile.photoURL = "http://cs11249.vkontakte.ru/u19180/e_d754d9b9.jpg";
        var rgo:RequestGameObject = new RequestGameObject(GameType.REGULAR, profile);

        var profile1:GameProfile = new GameProfile();
        profile1.id = 1;
        profile1.photoURL = "http://cs10541.vkontakte.ru/u7265902/d_8040d7fb.jpg";
        var rgo1:RequestGameObject = new RequestGameObject(GameType.REGULAR, profile1);

        var profile2:GameProfile = new GameProfile();
        profile2.id = 2;
        profile2.photoURL = "http://cs9656.vkontakte.ru/u196221/e_69797b06.jpg";
        var rgo2:RequestGameObject = new RequestGameObject(GameType.REGULAR, profile2);


        addRequest(rgo);
        addRequest(rgo1);
        addRequest(rgo2);
    }

    public function Settings() {
        fillRequestsTest();
    }

}
}