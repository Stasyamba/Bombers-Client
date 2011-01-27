package components.common.worlds.locations {
public class LocationType {

    public static const WORLD1_GRASSFIELDS:LocationType = new LocationType(0, "GRASS_FIELDS");
    public static const WORLD1_CASTLE:LocationType = new LocationType(1, "CASTLE");
    public static const WORLD1_MINE:LocationType = new LocationType(2, "MINE");
    public static const WORLD1_SNOWPEAK:LocationType = new LocationType(3, "SNOW_PEAK");
    public static const WORLD1_SEA:LocationType = new LocationType(4, "SEA");
    public static const WORLD1_ROCKET:LocationType = new LocationType(5, "ROCKET");
    public static const WORLD1_UFO:LocationType = new LocationType(6, "UFO");
    public static const WORLD1_SATTELITE:LocationType = new LocationType(7, "SATTELITE");
    public static const WORLD1_MOON:LocationType = new LocationType(8, "MOON");


    private var _value:int;
    private var _name:String;

    public function LocationType(value:int, name:String) {
        _value = value;
        _name = name;
    }

    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "Value: " + _value.toString() + "name: " + name;
    }
}
}