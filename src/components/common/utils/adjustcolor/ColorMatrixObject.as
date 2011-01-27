package components.common.utils.adjustcolor {
[Bindable]
public class ColorMatrixObject {
    public var hueShift:int = 0;
    public var saturationShift:Number = 1;
    public var contrastShift:Color = new Color(0, 0, 0);
    public var alphaContrastShift:Number = 0;
    public var brightnesShift:Color = new Color(0, 0, 0);

    public function ColorMatrixObject(hue:int = 0, saturation:Number = 1, contrast:Color = null, alphaContrast:Number = 0, brightnes:Color = null) {
        hueShift = hue;
        saturationShift = saturation;
        if (contrast != null) {
            contrastShift.cloneFrom(contrast);
        }

        alphaContrastShift = alphaContrast;

        if (brightnes != null) {
            brightnesShift.cloneFrom(brightnes);
        }
    }

    public function cloneFrom(cmo:ColorMatrixObject):void {
        this.hueShift = cmo.hueShift;
        this.saturationShift = cmo.saturationShift;
        this.contrastShift.cloneFrom(cmo.contrastShift);
        this.alphaContrastShift = cmo.alphaContrastShift;
        this.brightnesShift.cloneFrom(cmo.brightnesShift);
    }
}
}