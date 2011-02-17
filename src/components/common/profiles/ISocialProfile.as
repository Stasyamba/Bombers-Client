package components.common.profiles {

public interface ISocialProfile {

    function get id():String;

    function set id(value:String):void;

    function get name():String;

    function set name(value:String):void;

    function get surname():String;

    function set surname(value:String):void;

    function get photoURL():String;

    function set photoURL(value:String):void;

    function get profileLink():String;

    function set profileLink(value:String):void;
	
	function clone(profile: ISocialProfile): void;
	
    //public function get age:int;

    //public function get country:int;

    //public function get city:int;


    //public function getFriendsId():Array;

    //public function getAlbumsId():Array;

    //public function getAlbumsPhotosId(albumId:String):Array;
}

}