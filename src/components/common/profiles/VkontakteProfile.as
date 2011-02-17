package components.common.profiles {

public class VkontakteProfile implements ISocialProfile {
    public static const BOY:int = 2;
    public static const GIRL:int = 1;
    public static const SEX_UNDEFINDED:int = 0;

    public static const VKONTAKTE_USERPROFILE_PREFIX:String = "http://vkontakte.ru/id";

    private var _id:String = "";

    private var _photoURL:String = "";
    public var photoMediumSrc:String = "";
    public var photoBigSrc:String = "";

    private var _name:String = "";
    private var _surname:String = "";
    public var fullName:String = "";

    public var sex:int = BOY;
    public var age:int = 18;
    public var cityId:int = -1;

    private var _profileLink:String = "";

    public var isFriend:Boolean = false;

    public function VkontakteProfile(id:String) {
        this._id = id;
    }

	public function clone(profile:ISocialProfile): void
	{
		this._id = profile.id;
		this._name = profile.name;
		this._photoURL = profile.photoURL;
		this._surname = profile.surname;
		this._profileLink = profile.profileLink;
	}
	
    /* GET and SET */

    public function get profileLink():String {
        return _profileLink;
    }

    public function set profileLink(value:String):void {
        _profileLink = value;
    }

    public function get surname():String {
        return _surname;
    }

    public function set surname(value:String):void {
        _surname = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get photoURL():String {
        return _photoURL;
    }

    public function set photoURL(value:String):void {
        _photoURL = value;
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

}
}