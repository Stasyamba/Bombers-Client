package components.common.profiles
{
	public interface ISocialProfile
	{
		public function get id: String;
		public function get name: String;
		public function get surname: String;
		
		public function get age: int;
		
		public function get country: int;
		public function get city: int;
		
		public function get photoURL: String;
		public function get photoSmallURL: String;
		public function get profileLink: String;
		
		
		public function getFriendsId(): Array;
		public function getAlbumsId(): Array;
		public function getAlbumsPhotosId(albumId: String): Array;
	}
}