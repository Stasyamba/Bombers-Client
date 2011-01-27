package components.common.game.multygameresult {
import components.common.items.ItemProfileObject

public class GameResults {
    private var results:Array;
    private var items:Array;

    public function GameResults(resultsP:Array, itemsP:Array) {
        results = new Array
        items = new Array();

        for each(var r:Result in resultsP) {
            results.push(r);
        }

        // sort array
        //

        for each(var i:ItemProfileObject in itemsP) {
            items.push(i);
        }
    }

    public function getResults():Array {
        return results;
    }

    public function getItems():Array {
        return items;
    }


}
}