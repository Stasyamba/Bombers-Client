package components.common.base.expirance {
	import flash.geom.Point;

public class ExperienceManager {
    public function ExperienceManager() {
    }

	private var levelExperiencePair: Array;// type = [ ExperianceObject , ... ]
	
    public function getLevel(experience:int): ExperianceObject 
	{
        var res:int = 1;

        return new ExperianceObject(1,1);
    }
	
	public function getNextLevel(experience: int): ExperianceObject 
	{
		return new ExperianceObject(2,250);
	}
	
}
}