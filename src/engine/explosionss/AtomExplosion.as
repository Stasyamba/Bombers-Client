/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.model.explosionss.ExplosionType

public class AtomExplosion extends ExplosionBase implements IExplosion {

    private static const BRANCH_LENGTH:int = 2;

    public function AtomExplosion(map:IMap, owner:IBomber, centerX:int = -1, centerY:int = -1) {
        super(map, centerX, centerY, owner)
        timeToLive = type.timeToLive
    }

    private function addHorBranches(y:int):void {
        var firstSet:Boolean = false;

        addPoint(new ExplosionPoint(centerX, y, ExplosionPointType.CROSS,_owner,type));

        for (var i:int = -BRANCH_LENGTH; i < 0; i++) {
            if (map.validPoint(centerX + i, y)) {
                if (!firstSet) {
                    addPoint(new ExplosionPoint(centerX + i, y, ExplosionPointType.LEFT,_owner,type))
                    firstSet = true;
                }
                else
                    addPoint(new ExplosionPoint(centerX + i, y, ExplosionPointType.HORIZONTAL,_owner,type))
            }
        }

        firstSet = false;
        for (i = BRANCH_LENGTH; i > 0; i--) {
            if (map.validPoint(centerX + i, y)) {
                if (!firstSet) {
                    addPoint(new ExplosionPoint(centerX + i, y, ExplosionPointType.RIGHT,_owner,type))
                    firstSet = true;
                }
                else
                    addPoint(new ExplosionPoint(centerX + i, y, ExplosionPointType.HORIZONTAL,_owner,type))
            }
        }
    }

    private function addVertBranches(x:int):void {

        var firstSet:Boolean = false;

        addPoint(new ExplosionPoint(x, centerY, ExplosionPointType.CROSS,_owner,type));

        for (var i:int = -BRANCH_LENGTH; i < 0; i++) {
            if (map.validPoint(x, centerY + i)) {
                if (!firstSet) {
                    addPoint(new ExplosionPoint(x, centerY + i, ExplosionPointType.UP,_owner,type))
                    firstSet = true;
                }
                else
                    addPoint(new ExplosionPoint(x, centerY + i, ExplosionPointType.VERTICAL,_owner,type))
            }
        }

        firstSet = false;
        for (i = BRANCH_LENGTH; i > 0; i--) {
            if (map.validPoint(x, centerY + i)) {
                if (!firstSet) {
                    addPoint(new ExplosionPoint(x, centerY + i, ExplosionPointType.DOWN,_owner,type))
                    firstSet = true;
                }
                else
                    addPoint(new ExplosionPoint(x, centerY + i, ExplosionPointType.VERTICAL,_owner,type))
            }
        }
    }

    private function needVertBranches(x:int):Boolean {
        return (Math.abs(x - centerX) > 2) &&
                (Math.abs(x - centerX) % 3 == 0);
    }

    private function needHorBranches(y:int):Boolean {
        return (Math.abs(y - centerY) > 2) &&
                (Math.abs(y - centerY) % 3 == 0);
    }

    public function perform():void {
        addPoint(new ExplosionPoint(centerX, centerY, ExplosionPointType.CROSS,_owner,type));
        var x:int,y:int;

        //x-line
        for (x = 0; x < map.width; x++) {
            if (needVertBranches(x))
                addVertBranches(x);
            else
                switch (x) {
                    case 0:
                        addPoint(new ExplosionPoint(0, centerY, ExplosionPointType.LEFT,_owner,type))
                        break;
                    case map.width - 1:
                        addPoint(new ExplosionPoint(map.width - 1, centerY, ExplosionPointType.RIGHT,_owner,type))
                        break;
                    default:
                        addPoint(new ExplosionPoint(x, centerY, ExplosionPointType.HORIZONTAL,_owner,type))
                }
        }
        //y-line
        for (y = 0; y < map.height; y++) {
            if (needHorBranches(y))
                addHorBranches(y);
            else
                switch (y) {
                    case 0:
                        addPoint(new ExplosionPoint(centerX, 0, ExplosionPointType.UP,_owner,type))
                        break;
                    case map.height - 1:
                        addPoint(new ExplosionPoint(centerX, map.height - 1, ExplosionPointType.DOWN,_owner,type))
                        break;
                    default:
                        addPoint(new ExplosionPoint(centerX, y, ExplosionPointType.VERTICAL,_owner,type))
                }
        }

    }

    public function get type():ExplosionType {
        return ExplosionType.ATOM;
    }

    public function get damage():int {
        return 1;
    }
}
}