/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.data.location1.games {
import engine.utils.Utils

public class Games {

    [Embed(source="test_game.xml",mimeType="application/octet-stream")]
    private static const test_class:Class;
    [Embed(source="tutorial_1_game.xml",mimeType="application/octet-stream")]
    private static const tutorial_1_class:Class;

    private static var test_xml:XML;
    private static var tutorial_1_xml:XML;

    public static function get test():XML {
        if (test_xml == null) {
            test_xml = Utils.getXml(test_class);
        }
        return test_xml
    }

    public static function get tutorial_1():XML {
        if (tutorial_1_xml == null) {
            tutorial_1_xml = Utils.getXml(tutorial_1_class);
        }
        return tutorial_1_xml
    }
}
}
