package engine.weapons {
import mx.collections.ArrayList

public class WeaponMarket {
    private var priceList:ArrayList = new ArrayList();

    public function addPrice(weaponType:WeaponType, price:Price):void {
        priceList.addItem({weaponType:weaponType,price:price});
    }

    public function getPrice(weaponType:WeaponType):Price {
        for each (var obj:Object in priceList.source) {
            if (obj.weaponType == weaponType)
                return obj.price;
        }
        return null;
    }

    public function WeaponMarket() {
    }
}
}
