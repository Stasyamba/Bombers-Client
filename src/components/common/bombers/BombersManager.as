package components.common.bombers {
public class BombersManager {
    private var bombers:Array;


    public function BombersManager() {
        bombers = new Array();
    }

    public function getBomber(type:BomberType):BomberObject {
        var res:BomberObject = null;

        for each(var bo:BomberObject in bombers) {
            if (bo.type == type) {
                res = bo;
                break;
            }
        }

        return res;
    }

    public function getBombers():Array {
        return bombers;
    }

    public function addBomber(bt:BomberType):void {
        bombers.push(new BomberObject(
                bt,
                bt.accessRules,

                new BomberViewObject(
                        bt,
                        bt.name,
                        bt.description,
                        bt.bigImageURL
                        )
                ));
    }

}
}