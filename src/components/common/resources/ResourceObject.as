package components.common.resources {
[Bindable]
public class ResourceObject {
    private var _type:ResourceType;
    private var _value:int = 0;

    public function ResourceObject(type:ResourceType, amount:int = 0) {
        _type = type;
        _value = amount;
    }


    public function get type():ResourceType {
        return _type;
    }

    public function get value():int {
        return _value;
    }

    public function set value(value:int):void {
        if (value >= 0) {
            _value = value;
        }
    }

    public function cloneFrom(ro:ResourceObject):void {
        this._type = ro.type;
        this._value = ro.value;
    }

}
}