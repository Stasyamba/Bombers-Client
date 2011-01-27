package components.common.utils.adjustcolor {
public class Color {
    public var R:int = 0;
    public var G:int = 0;
    public var B:int = 0;

    public function Color(r:int = 0, g:int = 0, b:int = 0) {
        R = r;
        G = g;
        B = b;
    }

    public function cloneFrom(c:Color):void {
        R = c.R;
        G = c.G;
        B = c.B;
    }
}
}