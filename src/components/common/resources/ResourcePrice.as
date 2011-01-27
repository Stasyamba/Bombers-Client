package components.common.resources {
[Bindable]
public class ResourcePrice {
    private var _gold:ResourceObject = new ResourceObject(ResourceType.GOLD);
    private var _crystals:ResourceObject = new ResourceObject(ResourceType.CRYSTALS);
    private var _adamant:ResourceObject = new ResourceObject(ResourceType.ADAMANT);
    private var _antimatter:ResourceObject = new ResourceObject(ResourceType.ANTIMATTER);


    public function ResourcePrice(goldCount:int, crystalsCount:int, adamantCount:int, antimatterCount:int) {
        _gold.value = goldCount;
        _crystals.value = crystalsCount;
        _adamant.value = adamantCount;
        _antimatter.value = antimatterCount;
    }

    public function getResourceObjectArr():Array {
        return [gold, crystals, adamant, antimatter];
    }

    /* getters */

    public function get antimatter():ResourceObject {
        return _antimatter;
    }

    public function get adamant():ResourceObject {
        return _adamant;
    }

    public function get crystals():ResourceObject {
        return _crystals;
    }

    public function get gold():ResourceObject {
        return _gold;
    }


    public function getResource(type:ResourceType):ResourceObject {
        var res:ResourceObject = null;

        switch (type) {
            case ResourceType.GOLD:
                res = _gold;
                break;
            case ResourceType.ADAMANT:
                res = _adamant;
                break;
            case ResourceType.CRYSTALS:
                res = _crystals;
                break
            case ResourceType.ANTIMATTER:
                res = _antimatter;
                break;
        }

        return res;
    }

    public function setResourceValue(type:ResourceType, value:int):void {
        switch (type) {
            case ResourceType.GOLD:
                _gold.value = value;
                break;
            case ResourceType.ADAMANT:
                _adamant.value = value;
                break;
            case ResourceType.CRYSTALS:
                _crystals.value = value;
                break
            case ResourceType.ANTIMATTER:
                _antimatter.value = value;
                break;
        }
    }

    public function getDifference(source:ResourcePrice):ResourcePrice {

        var goldD:int = source.gold.value - this.gold.value;
        if (goldD < 0)
            goldD = Math.abs(goldD);
        else
            goldD = 0;

        var crysD:int = source.crystals.value - this.crystals.value;
        if (crysD < 0)
            crysD = Math.abs(crysD);
        else
            crysD = 0;

        var adamantD:int = source.adamant.value - this.adamant.value;
        if (adamantD < 0)
            adamantD = Math.abs(adamantD);
        else
            adamantD = 0;

        var antimatterD:int = source.antimatter.value - this.antimatter.value;
        if (antimatterD < 0)
            antimatterD = Math.abs(antimatterD);
        else
            antimatterD = 0;

        var dif:ResourcePrice = new ResourcePrice(goldD, crysD, adamantD, antimatterD);
        return dif;
    }

    public function isBiggerOrEqual(rp:ResourcePrice):Boolean {
        var res:Boolean = false;
        if (
                this.gold.value >= rp.gold.value &&
                        this.crystals.value >= rp.crystals.value &&
                        this.adamant.value >= rp.adamant.value &&
                        this.antimatter.value >= rp.antimatter.value) {
            res = true;
        }

        return res;
    }

    public function cloneFrom(rp:ResourcePrice):void {

        this._gold.cloneFrom(rp.getResource(ResourceType.GOLD));
        this._crystals.cloneFrom(rp.getResource(ResourceType.CRYSTALS));
        this._adamant.cloneFrom(rp.getResource(ResourceType.ADAMANT));
        this._antimatter.cloneFrom(rp.getResource(ResourceType.ANTIMATTER));

    }

    public function clone():ResourcePrice {
        return new ResourcePrice(_gold.value, _crystals.value, _adamant.value, _antimatter.value);
    }

    public function toString():String {
        var res:String = "";
        res += "Gold: " + gold.value.toString() + "\n";
        res += "Crystalls: " + crystals.value.toString() + "\n";
        res += "Adamant: " + adamant.value.toString() + "\n";
        res += "Antimatter: " + antimatter.value.toString() + "\n";

        return res;
    }
}
}