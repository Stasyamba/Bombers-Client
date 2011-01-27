package components.common.worlds.locations {
import components.common.utils.adjustcolor.ColorMatrixObject

import mx.core.IVisualElement

[Bindable]
public class LocationViewObject {
    private var _locationType:LocationType;

    public var name:String = "";
    public var describe:String = "";
    public var bgEnterURL:String = "";
    public var bgAboveEnterURL:String = "";

    public var cmoMultyPlayerButton:ColorMatrixObject = new ColorMatrixObject();
    public var cmoSinglePlayerButton:ColorMatrixObject = new ColorMatrixObject();
    public var cmoUniqActionButton:ColorMatrixObject = new ColorMatrixObject();

    public var specialActionContent:IVisualElement = null;
    public var imagePreviewURL:String;

    public var previewTextColor:uint = 0xd1d1d1;

    public function LocationViewObject(locactionTypeP:LocationType, nameP:String, descirbeP:String, bgEnterURLP:String = "", bgAboveEnterURLP:String = "", imagePreviewURLP:String = "", previewTextColor:uint = 0xd1d1d1, cmoSingleButton:ColorMatrixObject = null, cmoMultyButton:ColorMatrixObject = null, specialActionContentP:IVisualElement = null) {
        _locationType = locactionTypeP;

        name = nameP;
        describe = descirbeP;

        bgEnterURL = bgEnterURLP;
        bgAboveEnterURL = bgAboveEnterURLP;

        imagePreviewURL = imagePreviewURLP;

        this.previewTextColor = previewTextColor;

        if (cmoSingleButton != null) {
            cmoSinglePlayerButton.cloneFrom(cmoSingleButton);
        }

        if (cmoMultyButton != null) {
            cmoMultyPlayerButton.cloneFrom(cmoMultyButton);
        }
    }

    public function get locationType():LocationType {
        return _locationType;
    }

}
}