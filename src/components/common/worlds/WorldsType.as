package components.common.worlds {
public class WorldsType {
    public static const WORLD1:WorldsType = new WorldsType(0, "WROLD1");


    private var _value:int;
    private var _name:String;

    public function WorldsType(value:int, name:String) {
        _value = value;
        _name = name;
    }

    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }


}
}