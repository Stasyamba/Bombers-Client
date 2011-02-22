package components.common.base.expirance {
public class ExperienceManager {
    public function ExperienceManager() {
    }

    // type = [ ExperianceObject , ... ]
    public var levelExperiencePair:Array = new Array();

    public function getLevel(experience:int):ExperianceObject {
        for (var i:int = 0; i < levelExperiencePair.length; i++) {
            var eo:ExperianceObject = levelExperiencePair[i];
            if (experience < eo.experiance)
                return levelExperiencePair[i - 1]
        }
        return levelExperiencePair[levelExperiencePair.length - 1]
    }

    public function getNextLevel(experience:int):ExperianceObject {
        for (var i:int = 0; i < levelExperiencePair.length; i++) {
            var eo:ExperianceObject = levelExperiencePair[i];
            if (experience < eo.experiance)
                return levelExperiencePair[i]
        }
        return new ExperianceObject(-1,-1)
    }

}
}