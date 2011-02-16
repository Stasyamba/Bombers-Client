package components.common.game.multygameresult {
import engine.profiles.LobbyProfile

public class Result {
    public var lobbyProfile:LobbyProfile;
    public var place:int;
    public var exp:int;


    public function Result(lobbyProfile:LobbyProfile, place:int, exp:int) {
        this.lobbyProfile = lobbyProfile
        this.place = place
        this.exp = exp
    }
}
}