package components.wall
{
	import components.common.profiles.ISocialProfile;

	public class SendWallObject
	{
		public var up: ISocialProfile;
		public var postId: String;
		public var message: String;
		public var imageId: String;
		
		public function SendWallObject(u: ISocialProfile, p:String, m: String, i: String)
		{
			up = u;
			postId = p;
			message = m;
			imageId = i;
		}
		
		public function toString(): String
		{
			var res: String ="userId: " + up.id + " postID: "+postId + " message: "+message+" imageId: "+imageId;
			return res;
		}
	}
}