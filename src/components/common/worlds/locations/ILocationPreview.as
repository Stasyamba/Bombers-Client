package components.common.worlds.locations {
public interface ILocationPreview {
    function setOver(visible:Boolean, hueShift:int = 0, saturationShift:Number = 1):void;

    function openLocation():void;

    function getLocationType():LocationType;
}
}