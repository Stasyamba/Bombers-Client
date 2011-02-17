package components.common.bombers {
import components.common.base.server.ImagesPrefixes

public class BombersManager {
    private var bombers:Array;


    public function BombersManager() {
        bombers = new Array();

        bombers.push(new BomberObject(
                BomberType.FURY_JOE,
                [],

                new BomberViewObject(
                        BomberType.FURY_JOE,
                        "Мохнатый Джо",
                        "",
                        ImagesPrefixes.BOMBERS_PREFIX + "furyJoe/furyJoeBigImage.png"
                        )
                ));

        bombers.push(new BomberObject(
                BomberType.R2D3,
                [],

                new BomberViewObject(
                        BomberType.R2D3,
                        "Робот R2D3",
                        "",
                        ImagesPrefixes.BOMBERS_PREFIX + "r2d3/r2d3BigImage.png"
                        )
                ));

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
}
}