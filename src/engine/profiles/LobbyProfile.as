/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.profiles {
public class LobbyProfile {
    public var id:String
    public var nick:String
    public var photoURL:String
    public var experience:int
    public var playerId:int
    public var isReady:Boolean

    public function LobbyProfile(id:String, nick:String, photo:String, experience:int, playerId:int, isReady:Boolean) {
        this.id = id
        this.nick = nick
        this.photoURL = photo
        this.experience = experience
        this.playerId = playerId
        this.isReady = isReady
    }
}
}
