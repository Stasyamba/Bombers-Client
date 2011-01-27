package components.common.items {
[Bindable]
public class ItemViewObject {
    private var _type:ItemType;

    public var smallImageURL:String;
    public var anotherImageURL:String;
    public var name:String;
    public var description:String;

    public var favIconImageURL:String;

    public function ItemViewObject(typeP:ItemType, smallImageURLP:String, nameP:String, descriptionP:String, anotherImageURLP:String = "", favIconImageURLP:String = "") {
        _type = typeP;

        name = nameP;
        description = descriptionP;
        smallImageURL = smallImageURLP;
        anotherImageURL = anotherImageURLP;
        favIconImageURL = favIconImageURLP;
    }

    public function get type():ItemType {
        return _type;
    }

}
}