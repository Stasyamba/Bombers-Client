package components.common.base.window {
import mx.utils.ObjectUtil

public class WindowsManager {
    private var links:Array = new Array();

    public function WindowsManager() {
    }

    public function addWindow(link:IWindow):void {
        links.push(link);

        //mx.controls.Alert.show(links.length.toString());
        //mx.controls.Alert.show("after add:"+this.toString());
    }

    public function deleteAll():void {
        links = new Array();
    }

    public function deleteWindow(link:IWindow):void {
        var tempArray:Array = new Array();
        for each(var w:IWindow in links) {
            if (w != link) {
                tempArray.push(w);
            }
        }

        this.links = new Array();

        for each(var w1:IWindow in tempArray) {
            this.links.push(w1);
        }
    }

    public function closeWindow(link:IWindow, isCloseWrapper:Boolean = false):void {
        if (isCloseWrapper) {
            link.closeWrapper();
        } else {
            link.close();
        }

        deleteWindow(link);
    }

    public function closeAll(isCloseWrapper:Boolean):void {
        //	mx.controls.Alert.show("before close all:"+links.toString());
        for each(var l:IWindow in links) {
            closeWindow(l, isCloseWrapper);
        }
    }

    public function toString():String {
        var res:String = "";

        for each(var l:IWindow in links) {
            res += ObjectUtil.toString({link: l}) + "\n";
        }

        return res;
    }
}
}