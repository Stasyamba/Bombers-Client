package components.pages.world.toppanel.resources {
public interface IResourceView {
    function openToolTip():void;

    function closeToolTip():void;

    function acceleratedCloseToolTip():void;

    function resourceChanged(value:int):void;
}
}