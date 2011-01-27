package components.pages.global.inventory.topmenu {
public interface IToggleMenu {
    function changeState(state:int, enforced:Boolean = false):void;
}
}