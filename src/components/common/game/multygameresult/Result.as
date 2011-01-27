package components.common.game.multygameresult {
import engine.profiles.GameProfile

public class Result {
    public var gameProfile:GameProfile;
    public var score:int;

    public function Result(gp:GameProfile, sc:int) {
        gameProfile = gp;
        score = sc;
    }
}
}