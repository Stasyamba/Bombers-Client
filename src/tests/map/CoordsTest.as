/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package tests.map {
import engine.bombers.mapInfo.MapCoords
import engine.data.Consts
import engine.utils.Direction

import org.flexunit.Assert

public class CoordsTest {

    private var _map:MockMap

    private var _coords:MapCoords

    private var _dir:Direction

    private const _frameAmount = 100 / 30 //3,(3)


    private function stepFrame(dir:Direction) {
        switch (dir) {
            case Direction.NONE:
                return
            case Direction.LEFT:
                _coords.stepLeft(_frameAmount)
                break
            case Direction.RIGHT:
                _coords.stepRight(_frameAmount)
                break
            case Direction.UP:
                _coords.stepUp(_frameAmount)
                break
            case Direction.DOWN:
                _coords.stepDown(_frameAmount)
                break
        }
    }

    public function step(amount:Number, dir:Direction):void {
        switch (dir) {
            case Direction.NONE:
                return
            case Direction.LEFT:
                _coords.stepLeft(amount)
                break
            case Direction.RIGHT:
                _coords.stepRight(amount)
                break
            case Direction.UP:
                _coords.stepUp(amount)
                break
            case Direction.DOWN:
                _coords.stepDown(amount)
                break
        }
    }

    private function stepBlock(dir:Direction) {
        for (var i:int = 0; i < 12; i++)
            stepFrame(dir)
    }

    [Before]
    public function setUp():void {

        //  ffff
        //  fbbf
        //  fbbf
        //  ffff
        _map = new MockMap()
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(0, 0).willReturn(new MockMapBlock(0, 0, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(0, 1).willReturn(new MockMapBlock(0, 1, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(0, 2).willReturn(new MockMapBlock(0, 2, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(0, 3).willReturn(new MockMapBlock(0, 3, true))

        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(1, 0).willReturn(new MockMapBlock(1, 0, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(1, 1).willReturn(new MockMapBlock(1, 1, false))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(1, 2).willReturn(new MockMapBlock(1, 2, false))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(1, 3).willReturn(new MockMapBlock(1, 3, true))

        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(2, 0).willReturn(new MockMapBlock(2, 0, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(2, 1).willReturn(new MockMapBlock(2, 1, false))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(2, 2).willReturn(new MockMapBlock(2, 2, false))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(2, 3).willReturn(new MockMapBlock(2, 3, true))

        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(3, 0).willReturn(new MockMapBlock(3, 0, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(3, 1).willReturn(new MockMapBlock(3, 1, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(3, 2).willReturn(new MockMapBlock(3, 2, true))
        _map.expects("getBlock").times(int.MAX_VALUE).withArgs(3, 3).willReturn(new MockMapBlock(3, 3, true))

//        _map.expects("width").noArgs().willReturn(4)
//        _map.expects("height").noArgs().willReturn(4)

        _dir = Direction.NONE
    }

    [After]
    public function tearDown():void {
        _map = null
        _coords = null
    }

    //test setExplicit
    [Test]
    public function setExplicit():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)

        _coords.setExplicit(0, 0)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)

        _coords.setExplicit(0, 10)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 10)

        //border
        _coords.setExplicit(0, 20)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -20)

        _coords.setExplicit(0, 25)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -15)

        _coords.setExplicit(0, 40)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)

        _coords.setExplicit(0, 55)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 15)

        _coords.setExplicit(95, 80)
        Assert.assertTrue(_coords.elemX == 2)
        Assert.assertTrue(_coords.elemY == 2)
        Assert.assertTrue(_coords.xDef == 15)
        Assert.assertTrue(_coords.yDef == 0)
    }

    //change block
    [Test]
    public function testChangeBlockDown():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, Consts.BLOCK_END - 1)
        stepFrame(Direction.DOWN)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.yDef, Consts.BLOCK_START + _frameAmount - 1)
    }

    [Test]
    public function testChangeBlockUp():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, Consts.BLOCK_START + 1)
        stepFrame(Direction.UP)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.yDef, Consts.BLOCK_END - _frameAmount + 1)
    }

    [Test]
    public function testChangeBlockLeft():void {
        _coords = new MapCoords(null, _map, 1, 0, Consts.BLOCK_START + 1, 0)
        stepFrame(Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 0)
    }

    [Test]
    public function testChangeBlockRight():void {
        _coords = new MapCoords(null, _map, 0, 0, Consts.BLOCK_END - 1, 0)
        stepFrame(Direction.RIGHT)
        Assert.assertEquals(_coords.elemX, 1)
    }

    //border cross

    [Test]
    public function testChangeBlockDownWhenExactBorder():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, _frameAmount * 5)
        stepFrame(Direction.DOWN)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.yDef, Consts.BLOCK_START)
    }

    [Test]
    public function testNotChangeBlockUpWhenExactBorder():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, -_frameAmount * 5)
        stepFrame(Direction.UP)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.yDef, Consts.BLOCK_START)
    }

    [Test]
    public function testNotChangeBlockLeftWhenExactBorder():void {
        _coords = new MapCoords(null, _map, 1, 0, -_frameAmount * 5, 0)
        stepFrame(Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.xDef, Consts.BLOCK_START)
    }

    [Test]
    public function testChangeBlockRightExactBorder():void {
        _coords = new MapCoords(null, _map, 0, 0, _frameAmount * 5, 0)
        stepFrame(Direction.RIGHT)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.xDef, Consts.BLOCK_START)
    }

    //step blocks
    [Test]
    public function testStepsBlockDown():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.DOWN)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertTrue((Math.abs(_coords.yDef) < 10e-15))
    }

    [Test]
    public function testStepsBlockUp():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, 0)
        stepBlock(Direction.UP)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertTrue(Math.abs(_coords.yDef) < 10e-15)
    }

    [Test]
    public function testStepsBlockRight():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.RIGHT)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertTrue(Math.abs(_coords.xDef) < 10e-15)
    }

    [Test]
    public function testStepsBlockLeft():void {
        _coords = new MapCoords(null, _map, 1, 0, 0, 0)
        stepBlock(Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertTrue(Math.abs(_coords.xDef) < 10e-15)
    }

    //lines

    [Test]
    public function testLineDown():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.DOWN)
        stepBlock(Direction.DOWN)
        stepBlock(Direction.DOWN)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemY, 3)
    }

    [Test]
    public function testLineUp():void {
        _coords = new MapCoords(null, _map, 0, 3, 0, 0)
        stepBlock(Direction.UP)
        stepBlock(Direction.UP)
        stepBlock(Direction.UP)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemY, 0)
    }

    [Test]
    public function testLineLeft():void {
        _coords = new MapCoords(null, _map, 3, 0, 0, 0)
        stepBlock(Direction.LEFT)
        stepBlock(Direction.LEFT)
        stepBlock(Direction.LEFT)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemX, 0)
    }

    [Test]
    public function testLineRight():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.RIGHT)
        stepBlock(Direction.RIGHT)
        stepBlock(Direction.RIGHT)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemX, 3)
    }

    //map edges
    [Test]
    public function notGoLeftOut():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function notGoRightOut():void {
        _coords = new MapCoords(null, _map, 3, 0, 0, 0)
        stepBlock(Direction.RIGHT)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemX, 3)
    }

    [Test]
    public function notGoDownOut():void {
        _coords = new MapCoords(null, _map, 0, 3, 0, 0)
        stepBlock(Direction.DOWN)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        Assert.assertEquals(_coords.elemY, 3)
    }

    [Test]
    public function notGoUpOut():void {
        _coords = new MapCoords(null, _map, 0, 0, 0, 0)
        stepBlock(Direction.UP)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    //walls
    [Test]
    public function notGoLeftWall():void {
        _coords = new MapCoords(null, _map, 3, 1, 0, 0)
        stepBlock(Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notGoRightWall():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, 0)
        stepBlock(Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notGoDownWall():void {
        _coords = new MapCoords(null, _map, 1, 0, 0, 0)
        stepBlock(Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notGoUpWall():void {
        _coords = new MapCoords(null, _map, 1, 3, 0, 0)
        stepBlock(Direction.UP)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 0)
    }

    // don't interpolate when can't  (directions in method name are in interpolation order, last == input)
    [Test]
    public function notInterpolateUpRight():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, 5)
        stepBlock(Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
    }

    [Test]
    public function notInterpolateDownRight():void {
        _coords = new MapCoords(null, _map, 0, 2, 0, -5)
        stepBlock(Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 2)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
    }

    [Test]
    public function notInterpolateUpLeft():void {
        _coords = new MapCoords(null, _map, 3, 1, 0, 5)
        stepBlock(Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
    }

    [Test]
    public function notInterpolateDownLeft():void {
        _coords = new MapCoords(null, _map, 3, 2, 0, -5)
        stepBlock(Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 2)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
    }

    [Test]
    public function notInterpolateLeftDown():void {
        _coords = new MapCoords(null, _map, 1, 0, 5, 0)
        stepBlock(Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notInterpolateRightDown():void {
        _coords = new MapCoords(null, _map, 2, 0, -5, 0)
        stepBlock(Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 2)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notInterpolateLeftUp():void {
        _coords = new MapCoords(null, _map, 1, 3, 5, 0)
        stepBlock(Direction.UP)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function notInterpolateRightUp():void {
        _coords = new MapCoords(null, _map, 2, 3, -5, 0)
        stepBlock(Direction.UP)
        Assert.assertTrue(_coords.elemX == 2)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)
    }


    private function stepBy2(times:int, dir:Direction):void {
        for (var i:int = 0; i < times; i++) {
            step(2, dir)
        }
    }

    [Test]
    public function interpolateUpRight():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, -5)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -15)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 15)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function interpolateDownRight():void {
        _coords = new MapCoords(null, _map, 0, 2, 0, 5)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 2)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 15)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -15)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
        stepBy2(5, Direction.RIGHT)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function interpolateUpLeft():void {
        _coords = new MapCoords(null, _map, 3, 1, 0, -5)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 1)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -15)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 15)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)
    }

    [Test]
    public function interpolateDownLeft():void {
        _coords = new MapCoords(null, _map, 3, 2, 0, 5)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 2)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 15)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -15)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
        stepBy2(5, Direction.LEFT)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)

    }

    [Test]
    public function interpolateLeftDown():void {
        _coords = new MapCoords(null, _map, 1, 0, -5, 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == -15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
    }

    [Test]
    public function interpolateRightDown():void {
        _coords = new MapCoords(null, _map, 2, 0, 5, 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 2)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == -15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 0)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == 5)
    }

    [Test]
    public function interpolateLeftUp():void {
        _coords = new MapCoords(null, _map, 1, 3, -5, 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 1)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == -15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 5)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 0)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
    }

    [Test]
    public function interpolateRightUp():void {
        _coords = new MapCoords(null, _map, 2, 3, 5, 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 2)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == -15)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == -5)
        Assert.assertTrue(_coords.yDef == 0)
        stepBy2(5, Direction.UP)
        Assert.assertTrue(_coords.elemX == 3)
        Assert.assertTrue(_coords.elemY == 3)
        Assert.assertTrue(_coords.xDef == 0)
        Assert.assertTrue(_coords.yDef == -5)
    }

    //interpolation interruption

    [Test]
    public function stopInterpolateUpRight():void {
        _coords = new MapCoords(null, _map, 0, 1, 0, -5)
        stepBy2(2, Direction.RIGHT)
        _coords.setExplicit(0, 65)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, -15)
        stepBy2(1, Direction.RIGHT)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, -15)
    }

    [Test]
    public function stopInterpolateDownRight():void {
        _coords = new MapCoords(null, _map, 0, 2, 0, 5)
        stepBy2(2, Direction.RIGHT)
        _coords.setExplicit(0, 80)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(1, Direction.RIGHT)
        Assert.assertEquals(_coords.elemX, 0)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function stopInterpolateUpLeft():void {
        _coords = new MapCoords(null, _map, 3, 1, 0, -5)
        stepBy2(2, Direction.LEFT)
        _coords.setExplicit(120, 40)
        Assert.assertEquals(_coords.elemX, 3)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(1, Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 3)
        Assert.assertEquals(_coords.elemY, 1)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function stopInterpolateDownLeft():void {
        _coords = new MapCoords(null, _map, 3, 2, 0, 5)
        stepBy2(2, Direction.LEFT)
        _coords.setExplicit(120, 75)
        Assert.assertEquals(_coords.elemX, 3)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, -5)
        stepBy2(1, Direction.LEFT)
        Assert.assertEquals(_coords.elemX, 3)
        Assert.assertEquals(_coords.elemY, 2)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, -5)
    }

    [Test]
    public function stopInterpolateLeftDown():void {
        _coords = new MapCoords(null, _map, 1, 0, -5, 0)
        stepBy2(2, Direction.DOWN)
        _coords.setExplicit(45, 0)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 5)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(3, Direction.DOWN)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 5)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function stopInterpolateRightDown():void {
        _coords = new MapCoords(null, _map, 2, 0, 5, 0)
        stepBy2(2, Direction.DOWN)
        _coords.setExplicit(80, 0)
        Assert.assertEquals(_coords.elemX, 2)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(5, Direction.DOWN)
        Assert.assertEquals(_coords.elemX, 2)
        Assert.assertEquals(_coords.elemY, 0)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function stopInterpolateLeftUp():void {
        _coords = new MapCoords(null, _map, 1, 3, -5, 0)
        stepBy2(2, Direction.UP)
        _coords.setExplicit(40, 120)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.elemY, 3)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(5, Direction.UP)
        Assert.assertEquals(_coords.elemX, 1)
        Assert.assertEquals(_coords.elemY, 3)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

    [Test]
    public function stopInterpolateRightUp():void {
        _coords = new MapCoords(null, _map, 2, 3, 5, 0)
        stepBy2(2, Direction.UP)
        _coords.setExplicit(80, 120)
        Assert.assertEquals(_coords.elemX, 2)
        Assert.assertEquals(_coords.elemY, 3)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
        stepBy2(5, Direction.UP)
        Assert.assertEquals(_coords.elemX, 2)
        Assert.assertEquals(_coords.elemY, 3)
        Assert.assertEquals(_coords.xDef, 0)
        Assert.assertEquals(_coords.yDef, 0)
    }

}

}

import engine.bombers.CreatureBase
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.maps.bigObjects.BigObjectBase
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapBlocks.NullMapBlock
import engine.model.explosionss.ExplosionType
import engine.utils.Direction

import mx.collections.ArrayList

import org.mock4as.Mock
import org.osflash.signals.Signal

class MockMap extends Mock implements IMap {


    public function get blocks():Vector.<IMapBlock> {
        throw new Error()
    }

    public function getBlock(x:uint, y:uint):IMapBlock {
        record("getBlock", x, y)
        return expectedReturnFor("getBlock") as IMapBlock
    }

    public function get width():uint {
        return 4
    }

    public function get height():uint {
        return 4
    }

    public function getNeighbour(ofX:int, ofY:int, to:Direction):IMapBlock {
        if (!areCoordsOk(ofX, ofY))
            NullMapBlock.getInstance()
        switch (to) {
            case Direction.LEFT:
                return getLeft(ofX, ofY);
            case Direction.RIGHT:
                return getRight(ofX, ofY);
            case Direction.UP:
                return getUp(ofX, ofY);
            case Direction.DOWN:
                return getDown(ofX, ofY);
        }
        throw new ArgumentError("Invalid neighbour direction");
    }

    private function areCoordsOk(x:uint, y:uint):Boolean {
        return !(x >= width || y >= height || x < 0 || y < 0);
    }

    private function getLeft(ofX:int, ofY:int):IMapBlock {
        if (ofX == 0)
            return NullMapBlock.getInstance()
        return getBlock(ofX - 1, ofY);
    }

    private function getRight(ofX:int, ofY:int):IMapBlock {
        if (ofX == width - 1)
            return NullMapBlock.getInstance()
        return getBlock(ofX + 1, ofY);
    }

    private function getUp(ofX:int, ofY:int):IMapBlock {
        if (ofY == 0)
            return NullMapBlock.getInstance()
        return getBlock(ofX, ofY - 1);
    }

    private function getDown(ofX:int, ofY:int):IMapBlock {
        if (ofY == height - 1)
            return NullMapBlock.getInstance()
        return getBlock(ofX, ofY + 1);
    }

    public function get spawns():Array {
        throw new Error()
    }

    public function validPoint(x:int, y:int):Boolean {
        throw new Error()
    }

    public function get explosionPrints():ArrayList {
        throw new Error()
    }

    public function get higherBigObjects():Vector.<BigObjectBase> {
        throw new Error()
    }

    public function get lowerBigObjects():Vector.<BigObjectBase> {
        throw new Error()
    }

    public function get decorations():Vector.<BigObjectBase> {
        throw new Error()
    }

    public function get blockDestroyed():Signal {
        throw new Error()
    }

    public function getRandomBlock(f:Function):IMapBlock {
        throw new Error()
    }
}

class MockMapBlock implements IMapBlock {

    private var _x:int
    private var _y:int
    private var _cgThrough:Boolean


    public function MockMapBlock(x:int, y:int, cgThrough:Boolean) {
        _x = x
        _y = y
        _cgThrough = cgThrough
    }

    public function get x():int {
        return _x
    }

    public function get y():int {
        return _y
    }

    public function get state():IMapBlockState {
        throw new Error()
    }

    public function get object():IDynObject {
        throw new Error()
    }

    public function setObject(object:IDynObject):Boolean {
        throw new Error()
    }

    public function collectObject(byMe:Boolean):void {
        throw new Error()
    }

    public function get viewUpdated():Signal {
        throw new Error()

    }

    public function get hasExplosionPrint():Boolean {
        throw new Error()
    }

    public function get isExplodingNow():Boolean {
        throw new Error()
    }

    public function get explodedBy():ExplosionType {
        throw new Error()

    }

    public function get explosionStarted():Signal {
        throw new Error()

    }

    public function get explosionStopped():Signal {
        throw new Error()

    }

    public function stopExplosion():void {
        throw new Error()
    }

    public function setDieWall():void {
        throw new Error()
    }

    public function get objectCollected():Signal {
        throw new Error()

    }

    public function get objectSet():Signal {
        throw new Error()

    }

    public function setState(state:IMapBlockState):void {
        throw new Error()
    }

    public function get destroyed():Signal {
        throw new Error()

    }

    public function explodesAndStopsExplosion():Boolean {
        throw new Error()
    }

    public function canGoThrough(creature:CreatureBase = null):Boolean {
        return _cgThrough
    }

    public function canSetBomb():Boolean {
        throw new Error()
    }

    public function canExplosionGoThrough():Boolean {
        throw new Error()
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        throw new Error()
    }

    public function explode(expl:IExplosion):void {
        throw new Error()
    }

    public function get type():MapBlockType {
        throw new Error()

    }

    public function stateAfterExplosion(expl:IExplosion):MapBlockType {
        throw new Error()

    }

    public function get canShowObjects():Boolean {
        throw new Error()
    }

    public function get hiddenObject():IDynObject {
        throw new Error()

    }

    public function set hiddenObject(value:IDynObject):void {
        throw new Error()
    }

    public function get blinks():Boolean {
        throw new Error()
    }


}

