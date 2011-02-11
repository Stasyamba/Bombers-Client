/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.profiles {
public class LobbyProfile {
    public var id:int
    public var nick:String
    public var photoURL:String
    public var experience:int
    public var playerId:int

    public function LobbyProfile(id:int, nick:String, photo:String, experience:int, playerId:int) {
        this.id = id
        this.nick = nick
        this.photoURL = photo
        this.experience = experience
        this.playerId = playerId
    }
}
}
