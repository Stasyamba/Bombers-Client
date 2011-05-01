/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest.monsters.walking {
import engine.bombers.interfaces.IMapCoords
import engine.utils.Direction

import flash.geom.Point

public class PointToPointWS implements IWalkingStrategy {

    private var _points:Array

    private var _lastPoint:Point
    private var _lastPointIndex:int

    private var _direction:Direction

    private var _way:int = 1

    //points: Array of geom.Point. points[0] must be starting position
    public function PointToPointWS(points:Array) {
        _points = points
        _lastPoint = _points[_lastPointIndex = 0]
        _direction = getNewDirection()
    }

    private function get nextPoint():Point {
        return _points[_lastPointIndex + _way]
    }

    private function gotoNextPoint():void {
        _lastPoint = nextPoint
        _lastPointIndex += _way

        switch (_lastPointIndex) {
            case _points.length - 1:
                _way = -1
                break
            case 0:
                _way = 1
                break;
        }
    }

    public function getDirection(dir:Direction, _coords:IMapCoords):Direction {
        if (_coords.elemX == int(nextPoint.x) && _coords.elemY == int(nextPoint.y)) {
            changeDirection()
        }
        return _direction
    }

    private function changeDirection():void {
        gotoNextPoint()
        _direction = getNewDirection()
    }

    private function getNewDirection():Direction {
        if (nextPoint.x == _lastPoint.x) {
            if (nextPoint.y > _lastPoint.y)
                return Direction.DOWN
            else if (nextPoint.y < _lastPoint.y)
                return Direction.UP
            else
                throw new Error("can't perform PTP between to identical points")
        } else if (nextPoint.y == _lastPoint.y) {
            if (nextPoint.x > _lastPoint.x)
                return Direction.RIGHT
            else if (nextPoint.x < _lastPoint.x)
                return Direction.LEFT
            else
                throw new Error("can't perform PTP between to identical points")
        } else
            throw new Error("PTP can't be performed between point " + _lastPoint.x + ";" + _lastPoint.y + " and " + nextPoint.x + ";" + nextPoint.y)
    }
}
}
