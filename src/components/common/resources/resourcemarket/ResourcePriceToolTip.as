package components.common.resources.resourcemarket {
public class ResourcePriceToolTip {
    public function ResourcePriceToolTip() {
    }

    public static function getToolTipCost(cost:Number):String {
        // просклонять потом слово голосов и сделать для раных соц сетей свои подсказки

        return "Стоимость " + roundCost(cost).toString() + " голосов.";
    }

    private static function roundCost(cost:Number):Number {
         return ((int(cost * 100))/100)
    }

    public static function getToolTipDescibe(cost:int):String {
        var res:String = "";

        if (cost < 5) {
            res = "С учетом ваших дипломатических навыков, стоимость составила " + roundCost(cost).toString() + " голосов, со временем вы сможете покупать ресурсы по более выгодному для вас курсу.";

        } else if (cost < 15 && cost >= 5) {
            res = "Говорят ресурсов много не бывает, но зачем тебе столько?!!!";
        } else {
            res = "Вы точно хотите заставить противников рыдать? На такие средства вы сможете построить оружия немыслимой мощности!";
        }

        return res;
    }
}
}