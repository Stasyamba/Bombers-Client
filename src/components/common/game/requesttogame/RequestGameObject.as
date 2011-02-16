package components.common.game.requesttogame {
import engine.games.GameType
import engine.profiles.GameProfile

public class RequestGameObject {
    public var gameType:GameType;
    public var senderUserProfile:GameProfile;

    public var energyBet:int; // for duel
    public var sendTime:int;

    /* game parameters */
    public var gameName:String;
    public var gamePass:String;
    public var room:*;


    public function RequestGameObject(gameTypeP:GameType, senderUserProfileP:GameProfile, enegryBetP:int = 0) {
        gameType = gameTypeP;
        senderUserProfile = senderUserProfileP;
        energyBet = enegryBetP;
        sendTime = (new Date()).milliseconds;
    }

    public function isEqual(rgo:RequestGameObject):Boolean {
        var res:Boolean = false;
        if (rgo.senderUserProfile.id == this.senderUserProfile.id
                && rgo.gameName == this.gameName
                ) {
            res = true;
        }

        return res;
    }

}
}