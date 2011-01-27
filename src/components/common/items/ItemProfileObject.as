package components.common.items {
public class ItemProfileObject {
    public var itemType:ItemType;
    public var itemCount:int;

    public function ItemProfileObject(itemTypeP:ItemType, countP:int) {
        itemType = itemTypeP;
        itemCount = countP;
    }

    public function clone():ItemProfileObject {
        return new ItemProfileObject(itemType, itemCount);
    }

    public function toString():String {
        return "type: " + itemType.toString() + "\n count: " + itemCount.toString();
    }

}
}