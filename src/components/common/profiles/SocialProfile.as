package components.common.profiles {

public class SocialProfile {
    public static const VKONTAKTE:int = 0;
    public static const ODNOKLASSNIKI:int = 1;
    public static const MOI_MIR:int = 2;

	public static const TYPE_APP_FRINEDS: int =  0;
	public static const TYPE_NOT_APP_FRIENDS: int = 1;
	public static const TYPE_ALL: int = 2;
	
    public function SocialProfile() {
    }
	
	public static function getSocialProfileLink(id: String, type:int):String
	{
		var res: String = "";
		
		switch(type)
		{
			case VKONTAKTE:
				res = "http://vkontakte.ru/id"+id;
				break;
		}
		
		return res;
	}
}
}