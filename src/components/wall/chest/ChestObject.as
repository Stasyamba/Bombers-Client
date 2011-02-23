package components.wall.chest
{
	import components.common.resources.ResourceObject;

	public class ChestObject
	{
		public var price:ResourceObject = null;
		public var isOpened: Boolean = false;
		
		public function ChestObject(isOpenedP: Boolean, priceP: ResourceObject)
		{
			isOpened = isOpenedP;
			price = priceP;
		}
	}
}