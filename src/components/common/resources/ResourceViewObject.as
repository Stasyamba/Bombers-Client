package components.common.resources {
import flash.display.Bitmap

[Bindable]
public class ResourceViewObject {
    public var type:ResourceType;

    public var name:String = "";
    public var describe:String = "";

    public var color:uint = 0x000000;

    public var smallImage:Bitmap;
    public var bigImage:Bitmap;

    public function ResourceViewObject(typeP:ResourceType, nameP:String, describeP:String, colorP:uint, smallImageP:Bitmap, bigImageP:Bitmap) {
        type = typeP;

        name = nameP;
        describe = describeP;

        color = colorP;

        smallImage = smallImageP;
        bigImage = bigImageP;
    }
}
}