package components.common.items.collections
{
	import components.common.items.ItemType;

	public class ItemCollectionObject
	{
		public var type: ItemCollectionType;
		public var name: String;
		public var description: String;
		public var itemParts: Array = new Array(); // type = [ItemType, ...]
		public var previewURL: String = "";
		public var regards: ItemType;
		
		public function ItemCollectionObject(
			typeP: ItemCollectionType,
			nameP:String,
			descriptionP: String,
			itemPartsP: Array,
			previewURLP: String,
			regardsP:ItemType)
		{
			type = typeP;
			name = nameP;
			description = descriptionP;
			
			itemParts = new Array();
			
			for each(var it: ItemType in itemPartsP)
			{
				itemParts.push(it);
			}
			
			previewURL = previewURLP;
			
			regards = regardsP;
		}
		
		public function clone(): ItemCollectionObject
		{
			return new ItemCollectionObject(type, name, description, itemParts, previewURL, regards);
		}
	}
}