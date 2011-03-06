package components.common.items.collections
{
	import components.common.base.server.ImagesPrefixes;
	import components.common.items.ItemType;
	
	import mx.messaging.config.ServerConfig;

	public class ItemCollectionManager
	{
		private var itemsCollecitons: Array = new Array();
		
		public function ItemCollectionManager()
		{
			itemsCollecitons.push(new ItemCollectionObject(
				ItemCollectionType.AURA_WARM_NIGHT,
				"Теплая ночь",
				"Собрав ее вы получите древнюю ауру защиты ото льда. С помощью которой вы сможете без замедления перемещаться сквозь любые формы льда.",
				[ItemType.PART_BOOTS, ItemType.PART_CAP, ItemType.PART_GLOVES, ItemType.PART_MAGIC_SNOW],
				ImagesPrefixes.ITEM_COLLECTIONS +"warmNight.png",
				ItemType.AURA_WARM_NIGHT
			));
		}
		
		public function getItemsCollections(): Array
		{
			return itemsCollecitons;
		}
		
		public function getCollectionByType(collectionType: ItemCollectionType): ItemCollectionObject
		{
			var res: ItemCollectionObject = null;
			
			for each(var c: ItemCollectionObject in itemsCollecitons)
			{
				if(c.type == collectionType)
				{
					res = c.clone();
					break;
				}
			}
			
			return res;
			
		}
		
		public function getCollection(itemType: ItemType): ItemCollectionObject
		{
			var res: ItemCollectionObject = null;
			
			for each(var ic: ItemCollectionObject in itemsCollecitons)
			{
				for each(var it: ItemType in ic.itemParts)
				{
					if(it == itemType)
					{
						res = ic.clone();
						break;
					}
				}
			}
			
			return res;
		}
	}
}